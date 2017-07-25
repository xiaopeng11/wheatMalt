//
//  CustomPicker.m
//  wheatMalt
//
//  Created by Apple on 2017/7/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomPicker.h"

#define YEAR (0)
#define MONTH (1)
#define DAY (2)

@interface CustomPicker ()

@property(nonatomic,assign)NSInteger rowheight;

@property(nonatomic,strong)NSMutableArray *years;
@property(nonatomic,strong)NSMutableArray *months;
@property(nonatomic,strong)NSMutableArray *days;

@property(nonatomic,assign)NSInteger first;
@property(nonatomic,assign)NSInteger second;
@property(nonatomic,assign)NSInteger third;

@property(nonatomic,strong)NSCalendar *calendar;
@property(nonatomic,strong)NSDateFormatter *datefotm;

@end

@implementation CustomPicker

const NSInteger numberOfComponents = 3;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rowheight = 44;
        
        self.years = [NSMutableArray array];
        self.months = [NSMutableArray array];
        self.days = [NSMutableArray array];
        
        self.datefotm = [[NSDateFormatter alloc] init];
        self.datefotm.dateFormat = @"yyyy-MM-dd";
        
        self.calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:[NSDate date]];
        
        NSString *today = [self.datefotm stringFromDate:[NSDate date]];
        
        self.first = [components year] - 1990;  //年份位置
        self.second = [[today substringWithRange:NSMakeRange(5, 2)] integerValue] - 1;  //月份位置
        self.third = [[today substringWithRange:NSMakeRange(8, 2)] integerValue] - 1;  // 日期位置
        
        //年集合
        for (int i = 1990; i < [components year] + 1; i++) {
            [self.years addObject:[NSString stringWithFormat:@"%d年",i]];
        }
        
        //月集合
        for (int i = 1; i < [[today substringWithRange:NSMakeRange(5, 2)] integerValue] + 1; i++) {
            if (i < 10) {
                [self.months addObject:[NSString stringWithFormat:@"0%d月",i]];
            } else {
                [self.months addObject:[NSString stringWithFormat:@"%d月",i]];
            }
        }
        
        //日集合
        for (int i = 1; i < [[today substringWithRange:NSMakeRange(8, 2)] integerValue] + 1; i++) {
            if (i < 10) {
                [self.days addObject:[NSString stringWithFormat:@"0%d日",i]];
            } else {
                [self.days addObject:[NSString stringWithFormat:@"%d日",i]];
            }
        }
        
        
        self.delegate = self;
        self.dataSource = self;
        [self selectDay];

        
    }
    return self;
}

#pragma mark - Open methods
//默认选择位置
- (void)selectDay
{
    [self selectRow: self.first
        inComponent: YEAR
           animated: YES];
    
    [self selectRow: self.second
        inComponent: MONTH
           animated: YES];
    
    [self selectRow: self.third
        inComponent: DAY
           animated: YES];
}

#pragma mark - UIPickerViewDelegate
//宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

//内容
- (UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:20]];
    }
    NSString *title;
    switch (component) {
        case YEAR:
            title = self.years[row];
            break;
        case MONTH:
            title = self.months[row];
            break;
        case DAY:
            title = self.days[row];
            break;
        default:
            title = @"";
            break;
    }
    customLabel.text = title;
    customLabel.textColor = [UIColor blackColor];
    return customLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowheight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == YEAR){
        return self.years.count;
    } else if ( component == MONTH) {
        return self.months.count;
    } else {
        return self.days.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case YEAR:
            self.first = row;
            break;
        case MONTH:
            self.second = row;
            break;
        case DAY:
            self.third = row;
            break;
        default:
            break;
    }
    NSString *nowDate = [NSString stringWithFormat:@"%@-%@",self.years[self.first],self.months[self.second]];
    if (component == YEAR) {
        [self reloadMonthandDaysWithDateString:nowDate];
    } else if (component == MONTH){
        [self reloadDaysWithDateString:nowDate];
    }
    [pickerView reloadAllComponents];
    NSString *notiDate = [NSString stringWithFormat:@"%@-%@-%@",[nowDate substringToIndex:4],[nowDate substringWithRange:NSMakeRange(6, 2)],[self.days[self.third] substringToIndex:2]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeChanged" object:notiDate];
    
}

#pragma mark - Util
- (CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == YEAR) {
        return self.years[row];
    } else if(component == MONTH) {
        return self.months[row];
    } else {
        return self.days[row];
    }
}

/**
 刷新日数据源
 */
- (void)reloadDaysWithDateString:(NSString *)dateString
{
    NSString *string = [NSString stringWithFormat:@"%@-%@-01",[dateString substringToIndex:4],[dateString substringWithRange:NSMakeRange(6, 2)]];
    NSUInteger rows = 0;
    if ([[string substringToIndex:4] isEqualToString:[[self.datefotm stringFromDate:[NSDate date]] substringToIndex:4]]
        && [[string substringWithRange:NSMakeRange(5, 2)] isEqualToString:[[self.datefotm stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(5, 2)]]){
        rows = [[[self.datefotm stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(8, 2)] integerValue];
    } else {
        NSDate *date = [self.datefotm dateFromString:string];
        NSRange rangeofday = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        rows = rangeofday.length;
    }
    if (rows == self.days.count) {
        return;
    }
    [self.days removeAllObjects];
    for (int i = 1; i < rows + 1; i++) {
        if (i < 10) {
            [self.days addObject:[NSString stringWithFormat:@"0%d日",i]];
        } else {
            [self.days addObject:[NSString stringWithFormat:@"%d日",i]];
        }
    }
    self.third = [self reloadIndexWithIndex:self.third Count:self.days.count];

}

/**
 刷新月和日数据源
 */
- (void)reloadMonthandDaysWithDateString:(NSString *)dateString
{
    NSString *string = [NSString stringWithFormat:@"%@-%@-01",[dateString substringToIndex:4],[dateString substringWithRange:NSMakeRange(6, 2)]];
    
    NSUInteger months,days = 0;
    if ([[string substringToIndex:4] isEqualToString:[[self.datefotm stringFromDate:[NSDate date]] substringToIndex:4]]){
        months = [[[self.datefotm stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(5, 2)] integerValue];
        if (months < 10) {
            string = [NSString stringWithFormat:@"%@-0%ld-01",[dateString substringToIndex:4],months];
        } else {
            string = [NSString stringWithFormat:@"%@-%ld-01",[dateString substringToIndex:4],months];
        }
    } else {
        NSDate *date = [self.datefotm dateFromString:string];
        NSRange rangeofmonth = [self.calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date];
        months = rangeofmonth.length;
    }
    
    if ([[string substringToIndex:4] isEqualToString:[[self.datefotm stringFromDate:[NSDate date]] substringToIndex:4]]&& [[string substringWithRange:NSMakeRange(5, 2)] isEqualToString:[[self.datefotm stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(5, 2)]]){
        days = [[[self.datefotm stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(8, 2)] integerValue];
    } else {
        NSDate *date = [self.datefotm dateFromString:string];
        NSRange rangeofday = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        days = rangeofday.length;
    }
    
    if (months == self.months.count) {
        return;
    }
    if (months != self.months.count) {
        [self.months removeAllObjects];
        for (int i = 1; i < months + 1; i++) {
            if (i < 10) {
                [self.months addObject:[NSString stringWithFormat:@"0%d月",i]];
            } else {
                [self.months addObject:[NSString stringWithFormat:@"%d月",i]];
            }
        }
        self.second = [self reloadIndexWithIndex:self.second Count:self.months.count];
    }
    if (days == self.days.count) {
        return;
    }
    if (days != self.days.count){
        [self.days removeAllObjects];
        for (int i = 1; i < days + 1; i++) {
            if (i < 10) {
                [self.days addObject:[NSString stringWithFormat:@"0%d日",i]];
            } else {
                [self.days addObject:[NSString stringWithFormat:@"%d日",i]];
            }
        }
        self.third = [self reloadIndexWithIndex:self.third Count:self.days.count];
    }
    
}

/**
 刷新位置

 @param index 当前位置
 @param count 当前数组列表
 @return 返回位置
 */
- (NSInteger)reloadIndexWithIndex:(NSInteger)index Count:(NSInteger)count
{
    if (index >= count) {
        return count - 1;
    }
    return index;
}
@end
