//
//  EditShareViewViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "EditShareViewViewController.h"

@interface EditShareViewViewController ()
{
    UITextView *textView;
}
@end

@implementation EditShareViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"分享"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"Ellipsis_white" highImageName:@"Ellipsis_white" target:self action:@selector(showShareURL)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    imageView.image = [UIImage imageNamed:[self.dic valueForKey:@"imageName"]];
    [imageView setUserInteractionEnabled:YES];
    [self.view addSubview:imageView];
    
    UIView *tfBgview = [[UIView alloc] initWithFrame:[[self.dic valueForKey:@"TFrect"] CGRectValue]];
    [tfBgview setUserInteractionEnabled:YES];
    tfBgview.clipsToBounds = YES;
    tfBgview.layer.borderWidth = 1;
    tfBgview.layer.borderColor = [UIColor whiteColor].CGColor;
    tfBgview.layer.cornerRadius = 20;
    tfBgview.backgroundColor = [UIColor clearColor];
    [imageView addSubview:tfBgview];

    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, tfBgview.width - 20, tfBgview.height - 20)];
    textView.font = LargeFont;
    textView.textColor = [UIColor redColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = [self.dic valueForKey:@"text"];
    [tfBgview addSubview:textView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"share_clearbg"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:.3];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barTintColor = TabbarColor;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
- (void)showShareURL
{
    NSLog(@"分享");
}

@end
