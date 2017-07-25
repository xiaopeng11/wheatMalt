//
//  forgetPSViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "forgetPSViewController.h"

@interface forgetPSViewController ()<UITextFieldDelegate>

@property(nonatomic,assign)BOOL isSecureTextEntry;
@property(nonatomic,assign)BOOL isEnble;

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation forgetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawforgetPSUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
    
}

#pragma mark - 绘制修改密码UI
- (void)drawforgetPSUI
{
    [self NavTitleWithText:@"修改密码"];

    UIView *changePasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 134)];
    changePasswordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:changePasswordView];
    
    NSArray *labelStrings = @[@"原密码",@"新密码", @"确认新密码"];
    NSArray *placeholders = @[@"请输入原密码",@"请输入新密码", @"请确认新密码"];
    for (int i = 0; i < placeholders.count; i++) {
        UILabel *headeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12 + 45 * i, 90, 20)];
        headeLabel.font = SmallFont;
        headeLabel.text = labelStrings[i];
        [changePasswordView addSubview:headeLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12 + 45 * i, KScreenWidth - 110, 20)];
        textField.placeholder = placeholders[i];
        textField.secureTextEntry = YES;
        textField.tag = 800 + i;
        textField.font = SmallFont;
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [changePasswordView addSubview:textField];
        
        if (i < 2) {
            UIView *imaline = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
            [changePasswordView addSubview:imaline];
        }
        
    }
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(30, 184, KScreenWidth - 60, 40);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 20;
    button.backgroundColor = ButtonHColor;
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.titleLabel.font = SmallFont;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changepassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - 确定修改事件
- (void)changepassword:(UIButton *)button
{
    
    [self.view endEditing:YES];
    
    UITextField *oldpassword = (UITextField *)[self.view viewWithTag:800];
    UITextField *newpassword = (UITextField *)[self.view viewWithTag:801];
    UITextField *tonewpassword = (UITextField *)[self.view viewWithTag:802];
    
    if (oldpassword.text.length == 0) {
        //请输入新密码
        [BasicControls showAlertWithMsg:@"请输入原密码" addTarget:nil];
    } else if (newpassword.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入新密码" addTarget:nil];
    } else if (tonewpassword.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请确定新密码" addTarget:nil];
    } else if (![newpassword.text isEqualToString:tonewpassword.text]) {
        [BasicControls showAlertWithMsg:@"您的新密码不一致，请重新输入" addTarget:nil];
    } else if (oldpassword.text.length != 0 && newpassword.text.length != 0 && [newpassword.text isEqualToString:tonewpassword.text]) {
        //更改密码
        NSLog(@"%@%@%@",oldpassword,newpassword,tonewpassword);
    }
    
}


@end
