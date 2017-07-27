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
    phoneTF.text = @"18013574010";
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:phoneTF];
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbutton.frame = CGRectMake(20, 70, KScreenWidth - 40, 40);
    nextbutton.clipsToBounds = YES;
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
//    if (![BasicControls isMobileNumber:phoneTF.text]) {
//        [BasicControls showAlertWithMsg:@"请输入正确的手机号" addTarget:self];
//        return;
//    }
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];//请求
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:phoneTF.text forKey:@"phone"];
    NSData *data= [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:nil];
    //发送POST请求
    [requestManager POST:[wheatMalt_forgetPS_getCode ChangeInterfaceHeader] parameters:data success:^(AFHTTPRequestOperation                                                                                                                                                                                                                                                                                                                          *operation, id responseObject) {
        NSLog(@"121212");
            if ([responseObject[@"result"] isEqualToString:@"ok"]) {
                resetPSViewController *resetPSVC = [[resetPSViewController alloc] init];
                resetPSVC.phone = phoneTF.text;
                [self.navigationController pushViewController:resetPSVC animated:YES];
            } else {
                [BasicControls showAlertWithMsg:responseObject[@"message"] addTarget:nil];
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"121212\n%@",error);
    }];
    
//    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    [para setObject:@"" forKey:@"dq"];
//    
//    [HTTPRequestTool requestMothedWithPost:@"/crm/api/pub/getProvinceList.do" params:para success:^(id responseObject) {
//        NSLog(@"122222");
//    } failure:^(NSError *error) {
//        NSLog(@"-------%@",error);
//    }];
}

/**
 返回
 */
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
