//
//  RegisterViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    UIView *_bgView;

    UIButton *_acquireButton;                  //短信验证码
    UIButton *_isOrshowButton;                 //是否显示获取验证码按钮
}

@property (nonatomic, readwrite, retain)NSTimer *timer;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"注册"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, KScreenWidth, 170)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    NSArray *images = @[@"register_phone",@"register_code",@"register_ps"];
    NSArray *placerholders = @[@"请输入手机号码",@"请输入验证码",@"请输入密码"];
    
    for (int i = 0; i < images.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 60 * i, KScreenWidth - 40, 50)];
        view.layer.cornerRadius = 20;
        view.layer.borderColor = ButtonLColor.CGColor;
        view.layer.borderWidth = .2;
        view.tag = 11100 + i;
        [_bgView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        imageView.image = [UIImage imageNamed:images[i]];
        [view addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, 8, .2, 34)];
        lineView.backgroundColor = GraytextColor;
        [view addSubview:lineView];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.tag = 11110 + i;
        
        if (i == 1) {
            textField.frame = CGRectMake(65, 0, view.width - 65 - 110, 50);
        } else {
            textField.frame = CGRectMake(65, 0, view.width - 65 - 10, 50);
            if (i == 2) {
                textField.secureTextEntry = YES;
            }
        }
        if (i < 2) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = SmallFont;
        textField.placeholder = placerholders[i];
        [view addSubview:textField];
        
        if (i == 1) {
            _acquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            _acquireButton.frame = CGRectMake(view.width - 100, 10, 90, 30);
            [_acquireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_acquireButton setBackgroundColor:ButtonHColor];
            _acquireButton.titleLabel.font = SmallFont;
            _acquireButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            _acquireButton.layer.cornerRadius = 10;
            [_acquireButton addTarget:self action:@selector(getchecksms:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_acquireButton];
        }
    }
    
    UIButton *registerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerbutton.frame = CGRectMake(20, _bgView.bottom + 20, KScreenWidth - 40, 40);
    registerbutton.clipsToBounds = YES;
    registerbutton.layer.cornerRadius = 5;
    [registerbutton setBackgroundColor:ButtonHColor];
    [registerbutton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerbutton addTarget:self action:@selector(registerNewWheat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerbutton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮
/**
 获取验证码
 
 @param button 按钮
 */
- (void)getchecksms:(UIButton *)button
{
    [self.view endEditing:YES];
    UIView *bgview = (UIView *)[_bgView viewWithTag:11100];
    UIView *bgview2 = (UIView *)[_bgView viewWithTag:11101];
    UITextField *phoneTF = (UITextField *)[bgview viewWithTag:11110];
    UITextField *codeTF = (UITextField *)[bgview2 viewWithTag:11111];
    if (![BasicControls isMobileNumber:phoneTF.text]) {
        [BasicControls showAlertWithMsg:@"请输入正确的手机号" addTarget:self];
        return;
    }
    if (codeTF.text.length != 0) {
        codeTF.text = @"";
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:phoneTF.text forKey:@"phone"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Register_getCode params:para Token:NO success:^(id responseObject) {
        //网络请求获取验证码
        _acquireButton.enabled = NO;
        [_acquireButton setTitle:@"90s" forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        [self hideProgress];
    } Target:self];
}

/**
 注册
 */
- (void)registerNewWheat
{
    [self.view endEditing:YES];
    
    UIView *bgview1 = (UIView *)[_bgView viewWithTag:11100];
    UIView *bgview2 = (UIView *)[_bgView viewWithTag:11101];
    UIView *bgview3 = (UIView *)[_bgView viewWithTag:11102];
    UITextField *phoneTF = (UITextField *)[bgview1 viewWithTag:11110];
    UITextField *codeTF = (UITextField *)[bgview2 viewWithTag:11111];
    UITextField *psTF = (UITextField *)[bgview3 viewWithTag:11112];
    
    if (phoneTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入手机号" addTarget:self];
        return;
    }
    if (codeTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入验证码" addTarget:self];
        return;
    }
    if (psTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入密码" addTarget:self];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:phoneTF.text forKey:@"phone"];
    [para setObject:phoneTF.text forKey:@"name"];
    [para setObject:codeTF.text forKey:@"code"];
    [para setObject:psTF.text forKey:@"pwd"];
    [para setObject:@"华东地区/江苏省" forKey:@"quyu"];

    [HTTPRequestTool requestMothedWithPost:wheatMalt_Register params:para Token:NO success:^(id responseObject) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"注册成功");
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [BasicControls showMessageWithText:@"注册成功" Duration:2];
    } failure:^(NSError *error) {
        [self hideProgress];
    } Target:self];
}

//获取验证码倒计时
-(void)updateTimerText:(NSTimer*)theTimer
{
    
    NSString *countdown = _acquireButton.titleLabel.text;
    if([countdown isEqualToString:@"0s"])
    {
        [self.timer invalidate];
        self.timer = nil;
        _acquireButton.enabled = YES;
        [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_acquireButton setUserInteractionEnabled:YES];
    } else {
        int icountdown = [countdown intValue];
        icountdown = icountdown - 1;
        NSString *ncountdown = [[NSString alloc] initWithFormat:@"%ds", icountdown];
        
        if (isDevice4_4s)
        {
            _acquireButton.titleLabel.text = ncountdown;
        } else {
            [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
        }
        [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
    }
}

@end
