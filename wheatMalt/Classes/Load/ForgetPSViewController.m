//
//  ForgetPSViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ForgetPSViewController.h"

#import "resetPSViewController.h"
@interface ForgetPSViewController ()
{
    UITextField *phoneTF;
}
@end

@implementation ForgetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"忘记密码"];

    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
    label.font = SmallFont;
    label.text = @"手机号";
    [bgView addSubview:label];
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(label.right + 10, 0, KScreenWidth - 100, 50)];
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.font = SmallFont;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:phoneTF];
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbutton.frame = CGRectMake(20, 70, KScreenWidth - 40, 40);
    nextbutton.layer.cornerRadius = 5;
    [nextbutton setBackgroundColor:ButtonHColor];
    [nextbutton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextbutton addTarget:self action:@selector(resetNewPS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextbutton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件

/**
 下一步
 */
- (void)resetNewPS
{
    [self.view endEditing:YES];
    
    if (phoneTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入手机号" addTarget:self];
        return;
    }
    
    if (![BasicControls isMobileNumber:phoneTF.text]) {
        [BasicControls showAlertWithMsg:@"请输入正确的手机号" addTarget:self];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:phoneTF.text forKey:@"phone"];
    //发送POST请求
    [HTTPRequestTool requestMothedWithPost:wheatMalt_forgetPS_getCode params:para Token:NO success:^(id responseObject) {
        resetPSViewController *resetPSVC = [[resetPSViewController alloc] init];
        resetPSVC.phone = phoneTF.text;
    resetPSVC.phone = phoneTF.text;
        [self.navigationController pushViewController:resetPSVC animated:YES];
    } failure:^(NSError *error) {
    } Target:self];
}
@end
