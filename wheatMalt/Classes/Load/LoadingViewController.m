//
//  LoadingViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LoadingViewController.h"
#import "ForgetPSViewController.h"
#import "RegisterViewController.h"

#import "BaseTabBarController.h"

#import "BaseNavigationController.h"
@interface LoadingViewController ()<UITextFieldDelegate>
{
    UIView *firstView;
}
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawLoadingUI];
    
    [self getquyuData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
/**
 获取大区信息
 */
- (void)getquyuData
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([userdefault objectForKey:wheatMalt_LargeAreaData] == NULL) {
        [HTTPRequestTool requestMothedWithPost:wheatMalt_LargeArea params:nil Token:NO success:^(id responseObject) {
            [userdefault setObject:[responseObject objectForKey:@"list"] forKey:wheatMalt_LargeAreaData];
            [userdefault synchronize];
        } failure:^(NSError *error) {
        }  Target:nil];
    }
}

#pragma mark - 绘制UI
- (void)drawLoadingUI
{
    [self NavTitleWithText:@"登录"];
    
    //第一个页面
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 89)];
    firstView.userInteractionEnabled = YES;
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    //输入框
    NSArray *placeholders = @[@"请输入手机号",@"请输入密码"];
    NSArray *titles = @[@"手机",@"密码"];
    for (int i = 0; i < placeholders.count; i++) {
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 45 * i, 60, 45)];
        title.font = LargeFont;
        title.text = titles[i];
        [firstView addSubview:title];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(title.right + 10, 45 * i, KScreenWidth - 100, 45)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = LargeFont;
        textField.delegate = self;
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = @"18013574010";
        } else {
            textField.text = @"123456";
        }
        textField.placeholder = placeholders[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.tag = 10000 + i;
        if (i == placeholders.count - 1) {
            textField.secureTextEntry = YES;
        }
        [firstView addSubview:textField];
        
        
    }
    
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(20, 44.5, KScreenWidth - 20, .5)];
    [firstView addSubview:lineView];
    
    UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(20, firstView.bottom + 21, KScreenWidth - 40, 45)];
    loadButton.backgroundColor = ButtonHColor;
    loadButton.layer.cornerRadius = 4;
    [loadButton setTitle:@"登录" forState:UIControlStateNormal];
    loadButton.titleLabel.font = SmallFont;
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [loadButton addTarget:self action:@selector(loadtabAction) forControlEvents:UIControlEventTouchUpInside];
    loadButton.layer.cornerRadius = 5;
    
    [self.view addSubview:loadButton];
    
    UIButton *userRegisterButton = [[UIButton alloc] initWithFrame:CGRectMake(20, loadButton.bottom + 10, 70, 20)];
    userRegisterButton.backgroundColor = [UIColor clearColor];
    [userRegisterButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [userRegisterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    userRegisterButton.titleLabel.font = SmallFont;
    [userRegisterButton addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userRegisterButton];
    
    UIButton *forgetPas = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 90, userRegisterButton.top, 70, 20)];
    forgetPas.backgroundColor = [UIColor clearColor];
    [forgetPas setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPas setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetPas.titleLabel.font = SmallFont;
    [forgetPas addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPas];

}

#pragma mark - 按钮事件
/**
 登录
 */
- (void)loadtabAction
{
    [self.view endEditing:YES];

    UITextField *phone = (UITextField *)[firstView viewWithTag:10000];
    UITextField *password = (UITextField *)[firstView viewWithTag:10001];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:phone.text forKey:@"phone"];
    [para setObject:password.text forKey:@"pwd"];
    [para setObject:@"app" forKey:@"clientType"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_load params:para Token:NO success:^(id responseObject) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:[responseObject objectForKey:@"tokenid"] forKey:wheatMalt_Tokenid];
        [userdefault setObject:[responseObject objectForKey:@"VO"] forKey:wheatMalt_UserMessage];
        [userdefault synchronize];
        
        BaseTabBarController *BaseTabBarVC = [[BaseTabBarController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = BaseTabBarVC;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //获取负责人
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            [paras setObject:[[responseObject objectForKey:@"VO"] valueForKey:@"quyu"] forKey:@"quyu"];
            [HTTPRequestTool requestMothedWithPost:wheatMalt_chragePerson params:paras Token:YES success:^(id responseObject) {
                [userdefault setObject:[responseObject objectForKey:@"List"] forKey:wheatMalt_ChargePersonData];
                [userdefault synchronize];
            } failure:^(NSError *error) {
            }  Target:nil];
        });
    } failure:^(NSError *error) {
    } Target:self];
    
    
}
/**
 立即注册
 */
- (void)RegisterAction
{
    [self.view endEditing:YES];

    RegisterViewController *RegisterVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:RegisterVC animated:YES];
}

/**
 忘记密码
 */
- (void)forgetPassword
{
    [self.view endEditing:YES];

    ForgetPSViewController *ForgetPSVC = [[ForgetPSViewController alloc] init];
    [self.navigationController pushViewController:ForgetPSVC animated:YES];
}
@end
