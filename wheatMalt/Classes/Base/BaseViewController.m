//
//  BaseViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"
#define Wat_Default @"努力加载中..."
@interface BaseViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) MBProgressHUD *hudView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BaseBgColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    return  self.childViewControllers.count != 1;
}

/**
 创建转菊花视图
 
 @param view 父试图
 @param text 文本
 */
- (MBProgressHUD *)creatHUDViewWithView:(UIView *)view text:(NSString *)text
{
    MBProgressHUD *ph = [[MBProgressHUD alloc] initWithView:view];
    ph.labelText = text;
    
    ph.delegate = self;
    return ph;
}

/**
 显示菊花
 */
- (void)showProgress
{
    [self showProgressTitle:Wat_Default];
}

/**
 显示菊花
 
 @param title 文本
 */
- (void)showProgressTitle:(NSString *)title
{
    if (self.hudView) {
        [_hudView setLabelText:title];
    } else
    {
        _hudView = [self creatHUDViewWithView:self.view text:title];
        [self.view addSubview:_hudView];
    }
    [self.view bringSubviewToFront:_hudView];
    [_hudView show:YES];
}


/**
 隐藏菊花
 */
- (void)hideProgress
{
    if (self.hudView) {
        [self.view bringSubviewToFront:_hudView];
        [_hudView hide:NO];
    }
}

- (void)hudWasHidden
{
    [_hudView removeFromSuperview];
    _hudView.hidden = YES;
}


@end
