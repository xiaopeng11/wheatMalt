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
    bgView.layer.borderWidth = .3;
    bgView.layer.borderColor = GraytextColor.CGColor;
    
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
    [UIView animateWithDuration:1 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:.8 // 初始速度
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
            if ([[formatDic allKeys] containsObject:key]) {
                NSString *obj = [NSString stringWithFormat:@"%@",[dic valueForKey:key]];
                if (obj.length == 0 || obj == nil || obj == NULL ) {
                    [formatDic setObject:@"￥0" forKey:key];
                } else {
                    [formatDic setObject:[NSString stringWithFormat:@"￥%@",[obj FormatPriceWithPriceString]] forKey:key];
                }
            } else {
                [formatDic setObject:@"￥0" forKey:key];
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
    
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobileNum.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
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


/**
 json解析

 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
