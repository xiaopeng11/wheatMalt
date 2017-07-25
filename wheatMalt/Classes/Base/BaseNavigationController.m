//
//  BaseNavigationController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIBarButtonItem+Extension.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    
    self.navigationBar.barTintColor = TabbarColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:nil target:self action:@selector(goBack)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)goBack
{
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    [self popViewControllerAnimated:YES];
}


@end
