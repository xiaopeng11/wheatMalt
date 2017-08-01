//
//  AreaPicker.m
//  wheatMalt
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AreaPicker.h"

#define LargeArea (0)
#define Province (1)
#define City (2)
#define Town (3)

@interface AreaPicker ()

@property(nonatomic,assign)NSInteger rowheight;
@property(nonatomic,assign)NSInteger numberOfAreas;

@property(nonatomic,strong)NSMutableArray *largeAreas;
@property(nonatomic,strong)NSMutableArray *provinces;
@property(nonatomic,strong)NSMutableArray *citys;
@property(nonatomic,strong)NSMutableArray *towns;

@property(nonatomic,assign)NSInteger first;
@property(nonatomic,assign)NSInteger second;
@property(nonatomic,assign)NSInteger third;
@property(nonatomic,assign)NSInteger fourth;

@end

@implementation AreaPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rowheight = 44;
        self.numberOfAreas = 2;
        
        self.largeAreas = [NSMutableArray array];
        self.provinces = [NSMutableArray array];
        self.citys = [NSMutableArray array];
        self.towns = [NSMutableArray array];
        
        self.first = 0;
        self.second = 0;
        self.third = 0;
        self.fourth = 0;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSArray *largeAreas = [userdefaults objectForKey:wheatMalt_LargeAreaData];
        NSArray *provinces = [userdefaults objectForKey:wheatMalt_FirstAreaProvinces];

        //大区集合
        self.largeAreas  = [NSMutableArray arrayWithArray:largeAreas];
        //省集合
        self.provinces = [NSMutableArray arrayWithArray:provinces];
        //市集合
        self.citys = [NSMutableArray array];
        //区集合
        self.towns = [NSMutableArray array];
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
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
        [customLabel setFont:[UIFont systemFontOfSize:16]];
    }
    NSString *title;
    switch (component) {
        case LargeArea:
            title = self.largeAreas[row];
            break;
        case Province:
            title = self.provinces[row];
            break;
        case City:
            title = self.citys[row];
            break;
        case Town:
            title = self.towns[row];
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
    return self.numberOfAreas;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == LargeArea){
        return self.largeAreas.count;
    } else if ( component == Province) {
        return self.provinces.count;
    } else if ( component == City) {
        return self.citys.count;
    } else{
        return self.towns.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case LargeArea:
            self.first = row;
            break;
        case Province:
            self.second = row;
            break;
        case City:
            self.third = row;
            break;
        case Town:
            self.fourth = row;
            break;
        default:
            break;
    }
    if (component == LargeArea) {
        [self reloadProvinceAndCityAndTownData];
    } else if (component == Province){
        [self reloadCityAndTownData];
    } else if (component == City){
        [self reloadTownsData];
    } else {
        NSMutableArray *Areas = [NSMutableArray array];
        if (self.fourth != 0) {
            [Areas insertObject:self.towns[self.fourth] atIndex:0];
        }
        [Areas insertObject:self.citys[self.third] atIndex:0];
        [Areas insertObject:self.provinces[self.second] atIndex:0];
        [Areas insertObject:self.largeAreas[self.first] atIndex:0];

        NSString *notiDate = [Areas componentsJoinedByString:@"/"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChanged" object:notiDate];
    }
}

#pragma mark - Util
- (CGFloat)componentWidth
{
    return self.bounds.size.width / self.numberOfAreas;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == LargeArea) {
        return self.largeAreas[row];
    } else if(component == Province) {
        return self.provinces[row];
    } else if (component == City){
        return self.citys[row];
    } else {
        return self.towns[row];
    }
}

/**
 刷新区数据源
 */
- (void)reloadTownsData
{
    NSString *Nowprovince = self.provinces[self.second];
    NSString *NowCity = self.citys[self.third];
    if ([NowCity isEqualToString:[NSString stringWithFormat:@"%@负责人",Nowprovince]]) {
        self.numberOfAreas = 3;
        [self.towns removeAllObjects];
        NSMutableArray *Areas = [NSMutableArray array];
        [Areas insertObject:self.provinces[self.second] atIndex:0];
        [Areas insertObject:self.largeAreas[self.first] atIndex:0];
        NSString *notiDate = [Areas componentsJoinedByString:@"/"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChanged" object:notiDate];
        [self reloadAllComponents];
        return;
    }
    self.numberOfAreas = 4;
    NSMutableDictionary *town = [NSMutableDictionary dictionary];
    [town setObject:NowCity forKey:@"city"];
    [town setObject:Nowprovince forKey:@"province"];

    [HTTPRequestTool requestMothedWithPost:wheatMalt_Town params:town Token:NO success:^(id responseObject) {
        [self.towns removeAllObjects];;
        for (NSDictionary *town in [responseObject objectForKey:@"list"]) {
            [self.towns addObject:[town valueForKey:@"town"]];
        }
        [self.towns insertObject:[NSString stringWithFormat:@"%@负责人",NowCity] atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fourth = 0;
            NSMutableArray *Areas = [NSMutableArray array];
            [Areas insertObject:self.citys[self.third] atIndex:0];
            [Areas insertObject:self.provinces[self.second] atIndex:0];
            [Areas insertObject:self.largeAreas[self.first] atIndex:0];
            NSString *notiDate = [Areas componentsJoinedByString:@"/"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChanged" object:notiDate];
            [self reloadAllComponents];
            [self selectRow:0 inComponent:Town animated:YES];

        });
    } failure:^(NSError *error) {
    }  Target:nil];
  
}

/**
 刷新市区数据源
 */
- (void)reloadCityAndTownData
{
    NSString *Nowprovince = self.provinces[self.second];
    NSString *NowlargeArea = self.largeAreas[self.first];
    if ([Nowprovince isEqualToString:[NSString stringWithFormat:@"%@负责人",NowlargeArea]]) {
        self.numberOfAreas = 2;
        [self.towns removeAllObjects];
        [self.citys removeAllObjects];
        NSMutableArray *Areas = [NSMutableArray array];
        [Areas addObject:self.largeAreas[self.first]];
        NSString *notiDate = [Areas componentsJoinedByString:@"/"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChanged" object:notiDate];
        [self reloadAllComponents];
        return;
    }
    self.numberOfAreas = 3;
    NSMutableDictionary *city = [NSMutableDictionary dictionary];
    [city setObject:Nowprovince forKey:@"province"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_City params:city Token:NO success:^(id responseObject) {
        [self.citys removeAllObjects];
        for (NSDictionary *city in [responseObject objectForKey:@"list"]) {
            [self.citys addObject:[city valueForKey:@"city"]];
        }
        [self.citys insertObject:[NSString stringWithFormat:@"%@负责人",Nowprovince] atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fourth = 0;
            self.third = 0;
            
            NSMutableArray *Areas = [NSMutableArray array];
            [Areas insertObject:self.provinces[self.second] atIndex:0];
            [Areas insertObject:self.largeAreas[self.first] atIndex:0];
            NSString *notiDate = [Areas componentsJoinedByString:@"/"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChanged" object:notiDate];
            [self reloadAllComponents];
            [self selectRow:0 inComponent:City animated:YES];
        });
        
        
    } failure:^(NSError *error) {
    }  Target:nil];

}

/**
 刷新省市区数据源
 */
- (void)reloadProvinceAndCityAndTownData
{
    self.numberOfAreas = 2;
    self.fourth = 0;
    self.third = 0;
    self.second = 0;
    NSString *largeArea = self.largeAreas[self.first];
    
    NSMutableDictionary *dq = [NSMutableDictionary dictionary];
    [dq setObject:largeArea forKey:@"dq"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Province params:dq Token:NO success:^(id responseObject) {
        [self.provinces removeAllObjects];
        for (NSDictionary *provinced in [responseObject objectForKey:@"list"]) {
            [self.provinces addObject:[provinced valueForKey:@"province"]];
        }
        [self.provinces insertObject:[NSString stringWithFormat:@"%@负责人",largeArea] atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AreaChanged" object:largeArea];
            [self reloadAllComponents];
            
            [self selectRow:0 inComponent:Province animated:YES];
        });
    } failure:^(NSError *error) {
    }  Target:nil];
    
}




@end
