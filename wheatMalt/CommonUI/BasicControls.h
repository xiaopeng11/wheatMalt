//
//  BasicControls.h
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicControls : NSObject

+ (void)showMessageWithText:(NSString *)text
                   Duration:(NSTimeInterval)duration;

+ (void)showNDKNotifyWithMsg:(NSString *)showMsg  WithDuration:(CGFloat)duration speed:(CGFloat)speed;

+ (void)showAlertWithMsg:(NSString *)msg
               addTarget:(id)target;
+ (BOOL)isNewVersion;
+ (NSString *)returnTodayDate;
+ (NSString *)returnLastNameWithNameString:(NSString *)nameString;
+ (NSMutableArray *)ConversiondateWithData:(NSArray *)data;
+ (BOOL)judgeTodayWithDateString:(NSString *)dateString;
+ (UIView *)drawLineWithFrame:(CGRect)frame;
+ (NSMutableArray *)formatPriceStringInData:(NSMutableArray *)data Keys:(NSArray *)keys;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)MessagePersonInChargeWithUsrid:(NSNumber *)userid;
+ (BOOL)checkArrayDataWithDataList:(NSMutableArray *)dataList;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
