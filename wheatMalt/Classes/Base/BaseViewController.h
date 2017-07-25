//
//  BaseViewController.h
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//显示菊花
- (void)showProgress;

- (void)showProgressTitle:(NSString *)title;

//隐藏菊花
- (void)hideProgress;
@end
