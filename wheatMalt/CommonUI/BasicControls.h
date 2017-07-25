//
//  BasicControls.h
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicControls : NSObject
+ (void)showMessageNoBTWithText:(NSString *)text
                         Duration:(NSTimeInterval)duration;


+ (void)showSuccess1MessageWithText1:(NSString *)text1
                               Text2:(NSString *)text2
                               Text3:(NSString *)text3
                               Text4:(NSString *)text4
                            Duration:(NSTimeInterval)duration;


+ (void)showAlertWithMsg:(NSString *)msg
               addTarget:(id)target;
+ (BOOL)isNewVersion;
+ (NSString *)returnTodayDate;
+ (NSString *)returnLastNameWithNameString:(NSString *)nameString;
+ (NSMutableArray *)ConversiondateWithData:(NSArray *)data;
+ (BOOL)judgeTodayWithDateString:(NSString *)dateString;
+ (UIView *)drawLineWithFrame:(CGRect)frame;
+ (NSMutableArray *)formatPriceStringInData:(NSMutableArray *)data Keys:(NSArray *)keys;
@end
