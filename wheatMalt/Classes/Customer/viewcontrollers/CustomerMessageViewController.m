//
//  CustomerMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomerMessageViewController.h"
#import "X6WebView.h"
#import "AddCustomerViewController.h"
#import "SelectPersonInChargeViewController.h"
@interface CustomerMessageViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)NSString *personCharge;
@property(nonatomic,strong)NSString *warningTime;
@end

@implementation CustomerMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawCustomerMessageUI];
    
    self.personCharge = [self.customer valueForKey:@"ChargePerson"];
    self.warningTime = [self.customer valueForKey:@"warningTime"];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView *secondbgView = [_bgView viewWithTag:211111];
    for (int i = 0; i < 4; i++) {
        UITextField *textField = (UITextField *)[secondbgView viewWithTag:21000 + i];
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawCustomerMessageUI
{
    [self NavTitleWithText:[self.customer valueForKey:@"name"]];
    
    if (![[self.customer valueForKey:@"lx"] isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"编辑" target:self action:@selector(CustomerMessage)];
    } else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(saveCustomerMessage)];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BaseBgColor;
    [self.view addSubview:scrollView];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = BaseBgColor;
    [scrollView addSubview:_bgView];
    
    //第一部分
    UIView *CustomerMessageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    CustomerMessageBgView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:CustomerMessageBgView];
    
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 170) / 2, 20, 40, 40)];
    nameView.backgroundColor = HeaderBgColorArray[arc4random() % 10];
    nameView.textColor = [UIColor whiteColor];
    nameView.layer.cornerRadius = 20;
    nameView.font = [UIFont systemFontOfSize:13];
    nameView.textAlignment = NSTextAlignmentCenter;
    nameView.text = [BasicControls returnLastNameWithNameString:[self.customer valueForKey:@"name"]];
    [CustomerMessageBgView addSubview:nameView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(((KScreenWidth - 170) / 2) + 50, 25, 120, 30)];
    phoneLabel.text = [self.customer valueForKey:@"phone"];
    [CustomerMessageBgView addSubview:phoneLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 80);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [CustomerMessageBgView addSubview:button];
    
    //间隔
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CustomerMessageBgView.bottom, KScreenWidth, 10)];
    firstLineView.backgroundColor = BaseBgColor;
    [_bgView addSubview:firstLineView];
    
    //第二部分
    UIView *nextCustomerMessageBgView = [[UIView alloc] init];
    nextCustomerMessageBgView.backgroundColor = [UIColor whiteColor];
    nextCustomerMessageBgView.tag = 211110;
    [_bgView addSubview:nextCustomerMessageBgView];
    
    NSMutableArray *editTitles = [NSMutableArray arrayWithArray:@[@"下次提醒时间:",@"负责人",@"注册时间"]];
    if ([[self.customer valueForKey:@"lx"] isEqualToString:@"0"]) {
        [editTitles removeLastObject];
    }
    nextCustomerMessageBgView.frame = CGRectMake(0, firstLineView.bottom, KScreenWidth, editTitles.count * 45);

    for (int i = 0 ; i < editTitles.count; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * i, 150, 25)];
        title.font = SmallFont;
        title.text = editTitles[i];
        [nextCustomerMessageBgView addSubview:title];
        
        if (i < editTitles.count - 1) {
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [nextCustomerMessageBgView addSubview:lineView];
        }
        
        
        if (i == 2) {
            UILabel *registerTime = [[UILabel alloc] initWithFrame:CGRectMake(170, 90 + 10, KScreenWidth - 180, 25)];
            registerTime.font = SmallFont;
            registerTime.textAlignment = NSTextAlignmentRight;
            registerTime.text = [self.customer valueForKey:@"registerTime"];
            [nextCustomerMessageBgView addSubview:registerTime];
        } else {
            UIButton *editBT = [UIButton buttonWithType:UIButtonTypeCustom];
            editBT.frame = CGRectMake(170, 10 + 45 * i, KScreenWidth - 180, 25);
            editBT.backgroundColor = [UIColor whiteColor];
            editBT.tag = 22000 + i;
            [editBT addTarget:self action:@selector(editDetail:) forControlEvents:UIControlEventTouchUpInside];
            [nextCustomerMessageBgView addSubview:editBT];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 180 - 20, 25)];
            textLabel.textAlignment = NSTextAlignmentRight;
            textLabel.font = SmallFont;
            textLabel.tag = 22100 + i;
            if (i == 0) {
                textLabel.text = [self.customer valueForKey:@"warningTime"];
            } else {
                textLabel.text = [self.customer valueForKey:@"ChargePerson"];
            }
            [editBT addSubview:textLabel];
            
            UIImageView *leader = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 180 - 20, 2.5, 20, 20)];
            leader.image = [UIImage imageNamed:@"lead"];
            [editBT addSubview:leader];
        }
    }
    
    //间隔
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(0, nextCustomerMessageBgView.bottom, KScreenWidth, 10)];
    secondLineView.backgroundColor = BaseBgColor;
    [_bgView addSubview:secondLineView];
    
    //第三部分
    UIView *lastCustomerMessageBgView = [[UIView alloc] init];
    lastCustomerMessageBgView.tag = 211111;
    lastCustomerMessageBgView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:lastCustomerMessageBgView];
    
    if ([[self.customer valueForKey:@"lx"] isEqualToString:@"0"]) {
        //未注册
        lastCustomerMessageBgView.frame = CGRectMake(0, secondLineView.bottom, KScreenWidth, 260);
        _bgView.frame = CGRectMake(0, 0, KScreenWidth, 460);
        scrollView.contentSize = _bgView.height < KScreenHeight - 64 ? CGSizeMake(KScreenWidth, KScreenHeight) : CGSizeMake(KScreenWidth, 460 + 10);
        
        NSMutableArray *seondtitles = [NSMutableArray arrayWithArray:@[@"名称:",@"联系人:",@"手机号:",@"地址:"]];
        NSArray *placeholders = @[@"请输入名称",@"请输入联系人名称",@"请输入手机号",@"请输入地址"];
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[self.customer valueForKey:@"name"]];
        [values addObject:[self.customer valueForKey:@"lxr"]];
        [values addObject:[self.customer valueForKey:@"phone"]];
        [values addObject:[self.customer valueForKey:@"address"]];
        
        for (int i = 0; i < seondtitles.count; i++) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * i, 150, 25)];
            title.font = SmallFont;
            title.text = seondtitles[i];
            [lastCustomerMessageBgView addSubview:title];
            
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [lastCustomerMessageBgView addSubview:lineView];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 10 + 45 * i, KScreenWidth - 170, 25)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.placeholder = placeholders[i];
            textField.text = values[i];
            textField.font = SmallFont;
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 21000 + i;
            [lastCustomerMessageBgView addSubview:textField];
        }
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * seondtitles.count, 50, 25)];
        title.font = SmallFont;
        title.text = @"备注:";
        [lastCustomerMessageBgView addSubview:title];
        
        UIButton *textPlacerHolder = [UIButton buttonWithType:UIButtonTypeCustom];
        textPlacerHolder.frame = CGRectMake(60, 10 + 45 * seondtitles.count, KScreenWidth - 70, 25);
        textPlacerHolder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        textPlacerHolder.backgroundColor = [UIColor whiteColor];
        textPlacerHolder.titleLabel.font = SmallFont;
        [textPlacerHolder setTitleColor:commentColor forState:UIControlStateNormal];
        [textPlacerHolder setTitle:@"请输入备注内容" forState:UIControlStateNormal];
        [textPlacerHolder setUserInteractionEnabled:NO];
        textPlacerHolder.tag = 21010;
        [lastCustomerMessageBgView addSubview:textPlacerHolder];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(60, 5 + 45 * seondtitles.count, KScreenWidth - 70, 80)];
        textView.backgroundColor = [UIColor clearColor];
        textView.tag = 21000 + seondtitles.count;
        textView.delegate = self;
        textView.font = SmallFont;
        NSString *comments = [self.customer valueForKey:@"commens"];
        textView.text = comments;
        if (comments.length != 0) {
            textPlacerHolder.hidden = YES;
            if ([textView sizeThatFits:CGSizeMake(KScreenWidth - 70, 0)].height < 40) {
                textView.textAlignment = NSTextAlignmentRight;
            } else {
                textView.textAlignment = NSTextAlignmentLeft;
            }
        } else {
            textPlacerHolder.hidden = NO;
        }
        [lastCustomerMessageBgView addSubview:textView];
    } else {
        lastCustomerMessageBgView.frame = CGRectMake(0, secondLineView.bottom, KScreenWidth, KScreenHeight - 235);
        _bgView.frame = CGRectMake(0, 0, KScreenWidth, 400 + editTitles.count * 45);
        scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight);
        
        X6WebView *userTimeWebView = [[X6WebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 235)];;
        userTimeWebView.webViewString = @"";
        userTimeWebView.backgroundColor = [UIColor greenColor];
        [userTimeWebView setTop:98];
        [lastCustomerMessageBgView addSubview:userTimeWebView];
    }
}


#pragma mark - 按钮事件
/**
 编辑按钮
 */
- (void)CustomerMessage
{
    AddCustomerViewController *AddCustomerVC = [[AddCustomerViewController alloc] init];
    AddCustomerVC.customer = self.customer;
    [self.navigationController pushViewController:AddCustomerVC animated:YES];
}

/**
 保存
 */
- (void)saveCustomerMessage
{
    
    NSLog(@"保存");
}

/**
 拨打电话
 */
- (void)call
{
    //判断是否有电话=]vv
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",[self.customer valueForKey:@"phone"]];
    if (phone.length == 4) {
        [BasicControls showAlertWithMsg:@"当前用户没有手机号码" addTarget:nil];
    } else {
        //打电话
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:^(BOOL success) {
            }];
        }
        
    }
}

/**
 改变提醒时间/负责人

 @param button 按钮
 */
- (void)editDetail:(UIButton *)button
{
    if (button.tag == 22000) {
        //当前提醒时间
        NSString *nextWarningTime = [self.customer valueForKey:@"warningTime"];
        NSMutableDictionary *nextWraningTimeDic = [NSMutableDictionary dictionary];
        [nextWraningTimeDic setObject:nextWarningTime forKey:@"warningTime"];
        //可选择的时间
        NSDateFormatter *dataform = [[NSDateFormatter alloc] init];
        dataform.dateFormat = @"yyyy-MM-dd";
        NSDate *registerTime = [dataform dateFromString:[self.customer valueForKey:@"registerTime"]];
        NSDate *ExpireTime = [self getPriousorLaterDateFromDate:registerTime withMonth:1];
        NSMutableArray *dates = [self getCanSelectWarningTimeFromDate:[NSDate date] ToDate:ExpireTime];
        
        SelectPersonInChargeViewController *SelectPersonInChargeVC = [[SelectPersonInChargeViewController alloc] init];
        SelectPersonInChargeVC.personInCharge = nextWraningTimeDic;
        SelectPersonInChargeVC.datalist = dates;
        SelectPersonInChargeVC.key = @"warningTime";
        SelectPersonInChargeVC.canConsloe = YES;
        
        __weak CustomerMessageViewController *weakSelf = self;
        SelectPersonInChargeVC.changePersnInCharge = ^(NSDictionary *personMessage){
//            NSMutableDictionary *para = [NSMutableDictionary dictionary];
//            [para setObject:[personMessage valueForKey:@"warningTime"] forKey:@"txdate"];
//            [para setObject:[NSString stringWithFormat:@"%@",[weakSelf.customer valueForKey:@"customerID"]] forKey:@"ids"];
//
//            [HTTPRequestTool requestMothedWithPost:wheatMalt_CustomerWarningTime params:para Token:YES success:^(id responseObject) {
//                
//            } failure:^(NSError *error) {
//                
//            } Target:nil];
            
            weakSelf.warningTime = [personMessage valueForKey:@"warningTime"];
            
            UIView *secondBgview = (UIView *)[weakSelf.bgView viewWithTag:211110];
            UIButton *warningTimeBT = (UIButton *)[secondBgview viewWithTag:22000];
            UILabel *warningTimeLabel = (UILabel *)[warningTimeBT viewWithTag:22100];
            warningTimeLabel.text = [personMessage valueForKey:@"warningTime"];
            if ([[personMessage valueForKey:@"warningTime"] isEqualToString:@"请选择下次提醒时间"]) {
                warningTimeLabel.textColor = commentColor;
            } else {
                warningTimeLabel.textColor = [UIColor blackColor];
            }
            
            
        };
        [self.navigationController pushViewController:SelectPersonInChargeVC animated:YES];
    } else {
        SelectPersonInChargeViewController *SelectPersonInChargeVC = [[SelectPersonInChargeViewController alloc] init];
        SelectPersonInChargeVC.personInCharge = @{@"id":[self.customer valueForKey:@"chargeid"],@"name":[self.customer valueForKey:@"ChargePerson"]};
        SelectPersonInChargeVC.datalist = personData;
        SelectPersonInChargeVC.key = @"name";
        SelectPersonInChargeVC.canConsloe = YES;
        __weak CustomerMessageViewController *weakSelf = self;
        SelectPersonInChargeVC.changePersnInCharge = ^(NSDictionary *personMessage){
            weakSelf.personCharge = [personMessage valueForKey:@"name"];
            
            UIView *secondBgview = (UIView *)[weakSelf.bgView viewWithTag:211110];
            UIButton *chargePersonBT = (UIButton *)[secondBgview viewWithTag:22001];
            UILabel *personLabel = (UILabel *)[chargePersonBT viewWithTag:22101];
            personLabel.text = [personMessage valueForKey:@"name"];
            if ([[personMessage valueForKey:@"name"] isEqualToString:@"请选择负责人"]) {
                personLabel.textColor = commentColor;
            } else {
                personLabel.textColor = [UIColor blackColor];
            }
        };
        [self.navigationController pushViewController:SelectPersonInChargeVC animated:YES];
    }
}

/**
 获取一个月后的时间

 @param date 时间
 @param month 几个月
 @return 一个月后的时间
 */
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

/**
 可选日期数组

 @param date 开始日期
 @param expireDate 结束日期
 @return 数组
 */
- (NSMutableArray *)getCanSelectWarningTimeFromDate:(NSDate *)date ToDate:(NSDate *)expireDate
{
    NSMutableArray *dates = [NSMutableArray array];
    long long nowTime = [date timeIntervalSince1970], //开始时间
    endTime = [expireDate timeIntervalSince1970],//结束时间
    dayTime = 24*60*60,
    time = nowTime - nowTime%dayTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    while (time <= endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        NSMutableDictionary *onedate = [NSMutableDictionary dictionary];
        [onedate setObject:showOldDate forKey:@"warningTime"];
        [dates addObject:onedate];
        time += dayTime;
    }
    return dates;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UIView *lastbgView = (UIView *)[_bgView viewWithTag:211111];
    UIButton *textBT = (UIButton *)[lastbgView viewWithTag:21010];
    if (textView.text.length != 0) {
        textBT.hidden = YES;
    } else {
        textBT.hidden = NO;
    }
}

@end
