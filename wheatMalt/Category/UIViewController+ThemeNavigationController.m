//
//  UIViewController+ThemeNavigationController.m
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UIViewController+ThemeNavigationController.h"


@implementation UIViewController (ThemeNavigationController)
/**
 *  标题
 *
 *  @param text 标题文本
 */
- (void)NavTitleWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 0, 100, 44)];
    title.text = text;
    title.font = LargeFont;
    title.textAlignment = NSTextAlignmentCenter;
    [title sizeToFit];
    title.center = CGPointMake(KScreenWidth / 2.0, 42);
    
    self.navigationItem.titleView = title;
}

- (void)Nav2TitleWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 0, 100, 44)];
    title.text = text;
    title.textColor = [UIColor whiteColor];
    title.font = LargeFont;
    title.textAlignment = NSTextAlignmentCenter;
    [title sizeToFit];
    title.center = CGPointMake(KScreenWidth / 2.0, 42);
    
    self.navigationItem.titleView = title;
}

@end
