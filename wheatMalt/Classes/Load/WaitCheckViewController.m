//
//  WaitCheckViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WaitCheckViewController.h"

@interface WaitCheckViewController ()

@end

@implementation WaitCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self NavTitleWithText:@"提交成功"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"返回登录" target:self action:@selector(backloadAction)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2, KScreenHeight * .2, 100, 100)];
    imageView.image = [UIImage imageNamed:@"load_upsucessbook"];
    [self.view addSubview:imageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 70, 30, 30)];
    imageView1.image = [UIImage imageNamed:@"load_upsucess"];
    [imageView addSubview:imageView1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2, imageView.bottom + 10, 200, 40)];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"提交成功,等待审核...";
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, label.bottom + 10, KScreenWidth - 40, 70)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.numberOfLines = 0;
    label1.textColor = commentColor;
    label1.text = @"您的申请信息已成功提交！审核结果将以短信和通知的方式发送到您的手机上，请注意查收";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backloadAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
