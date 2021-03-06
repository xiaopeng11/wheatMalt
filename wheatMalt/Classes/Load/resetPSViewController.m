//
//  resetPSViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "resetPSViewController.h"

@interface resetPSViewController ()
{
    UITextField *_codeTF;
    UITextField *_newPSTF;
    
    UIButton *_acquireButton;                  //短信验证码
    UIButton *_isOrshowButton;                 //是否显示获取验证码按钮
}

@property (nonatomic, readwrite, retain)NSTimer *timer;

@end

@implementation resetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"设置新密码"];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = [NSString stringWithFormat:@"已向手机"];
    [self.view addSubview:label1];
    
    CGFloat width1 = [label1 sizeThatFits:CGSizeMake(0, 30)].width;
    label1.frame = CGRectMake(20, 0, width1, 30);
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = ButtonHColor;
    label2.text = [NSString stringWithFormat:@"%@*****%@",[self.phone substringToIndex:3],[self.phone substringFromIndex:8]];
    [self.view addSubview:label2];
    
    CGFloat width2 = [label2 sizeThatFits:CGSizeMake(0, 30)].width;
    label2.frame = CGRectMake(label1.right, 0, width2, 30);
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"发送一条短信";
    [self.view addSubview:label3];
    
    CGFloat width3 = [label3 sizeThatFits:CGSizeMake(0, 30)].width;
    label3.frame = CGRectMake(label2.right, 0, width3, 30);
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
    titleLabel1.font = SmallFont;
    titleLabel1.text = @"验证码";
    [bgView addSubview:titleLabel1];
    
    _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 0, KScreenWidth - 80 - 100, 50)];
    _codeTF.font = SmallFont;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:_codeTF];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 5, .5, 40)];
    lineView1.backgroundColor = GraytextColor;
    [bgView addSubview:lineView1];
    
    _acquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_acquireButton setTitle:@"90s" forState:UIControlStateNormal];
    _acquireButton.frame = CGRectMake(KScreenWidth - 90, 10, 80, 30);
    [_acquireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_acquireButton setBackgroundColor:ButtonHColor];
    _acquireButton.titleLabel.font = SmallFont;
    _acquireButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _acquireButton.layer.cornerRadius = 4;
    [_acquireButton setEnabled:NO];
    [_acquireButton addTarget:self action:@selector(getchecksms:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_acquireButton];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 49.5, KScreenWidth - 20, .2)];
    lineView2.backgroundColor = GraytextColor;
    [bgView addSubview:lineView2];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 60, 30)];
    titleLabel2.font = SmallFont;
    titleLabel2.text = @"新密码";
    [bgView addSubview:titleLabel2];
    
    _newPSTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel2.right, 50, KScreenWidth - 80, 50)];
    _newPSTF.font = SmallFont;
    _newPSTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newPSTF.autocorrectionType = UITextAutocorrectionTypeYes;
    _newPSTF.secureTextEntry = YES;
    [bgView addSubview:_newPSTF];
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame = CGRectMake(20, bgView.bottom + 20, KScreenWidth - 40, 40);
    surebutton.layer.cornerRadius = 5;
    [surebutton setBackgroundColor:ButtonHColor];
    [surebutton setTitle:@"确定" forState:UIControlStateNormal];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surebutton addTarget:self action:@selector(changePS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surebutton];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:nil repeats:YES];

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
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:self.phone forKey:@"phone"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_forgetPS_getCode params:para Token:NO success:^(id responseObject) {
        //网络请求获取验证码
        _acquireButton.enabled = NO;
        NSString *title = [NSString stringWithFormat:@"%@s",[responseObject valueForKey:@"message"]];
        [_acquireButton setTitle:title forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
    }  Target:self];
}

/**
 设置新密码
 */
- (void)changePS
{
    [self.view endEditing:YES];

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:self.phone forKey:@"phone"];
    [para setObject:_codeTF.text forKey:@"code"];
    [para setObject:_newPSTF.text forKey:@"pwd"];

    [HTTPRequestTool requestMothedWithPost:wheatMalt_forgetPS_resetPS params:para Token:NO success:^(id responseObject) {
        [self .navigationController popToRootViewControllerAnimated:YES];
        [BasicControls showMessageWithText:@"设置成功" Duration:2];
    } failure:^(NSError *error) {
        
    }  Target:self];
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
