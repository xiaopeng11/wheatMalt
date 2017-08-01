//
//  BasicControls.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BasicControls.h"
#import "BDKNotifyHUD.h"
@implementation BasicControls

/**
 提示

 @param msg 标题
 @param target 对象
 */
+ (void)showAlertWithMsg:(NSString *)msg
               addTarget:(id)target
{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)showNDKNotifyWithMsg:(NSString *)showMsg  WithDuration:(CGFloat)duration speed:(CGFloat)speed
{
    BDKNotifyHUD *notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@""] text:showMsg];
    notify.frame = CGRectMake(0, 64, 0, 0);
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:notify];
    [notify presentWithDuration:duration speed:speed inView:window completion:^{
        [notify removeFromSuperview];
    }];
}

+ (void)showMessageWithText:(NSString *)text
                   Duration:(NSTimeInterval)duration
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 120) / 2, (KScreenHeight - 120) / 2, 120, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    
    bgView.layer.shadowOpacity = .8;// 阴影透明度
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bgView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 40, 40)];
    imgeView.image = [UIImage imageNamed:@"sucess_h"];
    [bgView addSubview:imgeView];
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 80, 30)];
    [tipLabel setText:text];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipLabel];
    
    // 设置时间和动画效果
    [UIView animateWithDuration:2 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:.5 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         // code...
                         bgView.alpha = 1.0;
                         bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                         // 动画完成后执行
                         // code...
                         [bgView removeFromSuperview];
                     }];
}


/**
 操作成功动画

 */
+ (void)showMessageNoBTWithText:(NSString *)text
                         Duration:(NSTimeInterval)duration
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 80) / 2, (KScreenHeight - 80) / 2, 80, 80)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    bgView.layer.cornerRadius = 5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
    imgeView.image = [UIImage imageNamed:@"success"];
    [bgView addSubview:imgeView];
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    [tipLabel setText:text];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:tipLabel];
    
    // 设置时间和动画效果
    [UIView animateWithDuration:duration delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画完毕从父视图移除
        [bgView removeFromSuperview];
    }];
}

/**
 改变负责人成功
 
 */
+ (void)showSuccess1MessageWithText1:(NSString *)text1
                               Text2:(NSString *)text2
                               Text3:(NSString *)text3
                               Text4:(NSString *)text4
                          Duration:(NSTimeInterval)duration
{
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    superView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    [[UIApplication sharedApplication].keyWindow addSubview:superView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    [superView addSubview:bgView];
    
    UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [tipLabel1 setText:text1];
    tipLabel1.font = SmallFont;
    tipLabel1.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [tipLabel2 setText:text2];
    tipLabel2.font = SmallFont;
    tipLabel2.textColor = ButtonLColor;
    tipLabel2.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipLabel2];
    
    UILabel *tipLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    [tipLabel3 setText:text3];
    tipLabel3.font = SmallFont;
    tipLabel3.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipLabel3];
    
    UILabel *tipLabel4 = [[UILabel alloc] initWithFrame:CGRectZero];
    [tipLabel4 setText:text4];
    tipLabel4.font = SmallFont;
    tipLabel4.textColor = ButtonHColor;
    tipLabel4.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipLabel4];
    
    CGFloat tipLabel3width = [tipLabel3 sizeThatFits:CGSizeMake(0, 34)].width;
    CGFloat tipLabel2width = [tipLabel2 sizeThatFits:CGSizeMake(0, 34)].width;
    
    if (tipLabel3width >= tipLabel2width) {
        bgView.frame = CGRectMake((KScreenWidth - tipLabel3width - 30) / 2, (KScreenHeight - 150) / 2, tipLabel3width + 30, 150);
        tipLabel1.frame = CGRectMake(15, 15, tipLabel3width, 30);
        tipLabel2.frame = CGRectMake(15, 45, tipLabel3width, 30);
        tipLabel3.frame = CGRectMake(15, 75, tipLabel3width, 30);
        tipLabel4.frame = CGRectMake(15, 105, tipLabel3width, 30);
    } else {
        if (tipLabel2width > KScreenWidth / 2) {
            tipLabel2width = KScreenWidth / 2;
            tipLabel2.numberOfLines = 0;
        }
        CGFloat tipLabel2height = [tipLabel2 sizeThatFits:CGSizeMake(KScreenWidth / 2, 0)].height;

        bgView.frame = CGRectMake((KScreenWidth - tipLabel2width - 30) / 2, (KScreenHeight - 150) / 2, tipLabel2width + 30, 150);
        tipLabel1.frame = CGRectMake(15, 15, tipLabel2width, 30);
        tipLabel2.frame = CGRectMake(15, tipLabel1.bottom, tipLabel2width, tipLabel2height);
        tipLabel3.frame = CGRectMake(15, tipLabel2.bottom, tipLabel2width, 30);
        tipLabel4.frame = CGRectMake(15, tipLabel3.bottom, tipLabel2width, 30);
    }
    
    // 设置时间和动画效果
    [UIView animateWithDuration:duration delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        superView.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画完毕从父视图移除
        [superView removeFromSuperview];
    }];
}

/**
 新版本判断
 
 @return 是否
 */
+ (BOOL)isNewVersion
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastVersion = [defaults objectForKey:SYSTEMVERSION];
    
    //获取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[SYSTEMVERSION];
    
    if (![currentVersion isEqualToString:lastVersion])
    {
        [defaults setObject:currentVersion forKey:SYSTEMVERSION];
        return YES;
    }else
    {
        return NO;
    }
}

/**
 *  今日日期
 */
+ (NSString *)returnTodayDate
{
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    dateString = [dateString substringToIndex:10];
    return dateString;
}

/**
 头像名字
 
 @param nameString 名称
 @return 显示名称
 */
+ (NSString *)returnLastNameWithNameString:(NSString *)nameString
{
    if (nameString.length > 2) {
        return [nameString substringWithRange:NSMakeRange(nameString.length - 2, 2)];
    } else {
        return nameString;
    }
}

/**
 分割线
 
 @param frame 位置
 */
+ (UIView *)drawLineWithFrame:(CGRect)frame
{
    UIView *lineview = [[UIView alloc] initWithFrame:frame];
    lineview.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    return lineview;
}

/**
 返回处理日期格式后的数组

 @param data 待处理的数组
 @return 新的数组
 */
+ (NSMutableArray *)ConversiondateWithData:(NSArray *)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *dateString = [dic valueForKey:@"date"];
        if ([BasicControls judgeTodayWithDateString:[dateString substringToIndex:10]]) {
            [mutDic setObject:@"今天" forKey:@"date"];
        }
        [array addObject:mutDic];
    }
    return array;
}

/**
 判断是否是今天
 
 @param dateString 日期文本
 @return 是/否
 */
+ (BOOL)judgeTodayWithDateString:(NSString *)dateString
{
    NSDateFormatter *dataform = [[NSDateFormatter alloc] init];
    dataform.dateFormat = @"yyyy-MM-dd";
    if ([[dataform stringFromDate:[NSDate date]] isEqualToString:dateString]) {
        return YES;
    }
    return NO;
}

/**
 格式化数据中的金额
 
 @param data 需要格式化的数据
 @param keys 需要格式化的参数
 @return 格式化后的数据
 */
+ (NSMutableArray *)formatPriceStringInData:(NSMutableArray *)data Keys:(NSArray *)keys
{
    NSMutableArray *formatData = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSMutableDictionary *formatDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        for (NSString *key in keys) {
            NSString *obj = [NSString stringWithFormat:@"%@",[dic valueForKey:key]];
            if (obj.length != 0) {
                [formatDic setObject:[NSString stringWithFormat:@"￥%@",[obj FormatPriceWithPriceString]] forKey:key];
            } else {
                [formatDic setObject:obj forKey:key];
            }
            
        }
        [formatData addObject:formatDic];
    }
    return formatData;
}




/**
 判断手机号是否合法

 @param mobileNum 输入
 @return 是否合法
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";

    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 当前信息的负责人是否是自己

 @param userid 当前信息的负责人
 @return 是/否
 */
+ (BOOL)MessagePersonInChargeWithUsrid:(NSNumber *)userid
{
    NSUserDefaults *userdefalut = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserMessage = [userdefalut objectForKey:wheatMalt_UserMessage];
    if ([[UserMessage valueForKey:@"id"] intValue] == [userid intValue]) {
        return YES;
    }
    
    return NO;
}


/**
 是否选中

 @param dataList 数据源
 @return 是/否
 */
+ (BOOL)checkArrayDataWithDataList:(NSMutableArray *)dataList
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dataList) {
        [array addObject:[dic valueForKey:@"isChoose"]];
    }
    if ([array containsObject:@YES]) {
        return YES;
    }
    return NO;
}

@end
