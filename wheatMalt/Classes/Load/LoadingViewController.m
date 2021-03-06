//
//  LoadingViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/25.
//  Copyright © 2017年 Apple. All rights reserved.
//
#define HMNewfeatureImageCount 5
#import "LoadingViewController.h"
#import "ForgetPSViewController.h"
#import "RegisterViewController.h"

#import "BaseTabBarController.h"

#import "BaseNavigationController.h"

@interface LoadingViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *firstView;
}
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawLoadingUI];
    
    if ([BasicControls isNewVersion]) {
        // 1.添加UISrollView
        [self setupScrollView];
    
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"load_navibg"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = TabbarColor;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(HMNewfeatureImageCount * KScreenWidth, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:scrollView];
    
    // 2.添加图片
    for (int i = 0; i < HMNewfeatureImageCount - 1; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        imageView.backgroundColor = [UIColor whiteColor];
        NSString *name = [NSString stringWithFormat:@"feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if (i == HMNewfeatureImageCount - 2) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * KScreenWidth, 0, KScreenWidth, KScreenHeight)];
            view.backgroundColor = [UIColor clearColor];
            [scrollView addSubview:view];
        }
    }
    
}

/**
 登录UI
 */
- (void)drawLoadingUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    headerBgView.image = [UIImage imageNamed:@"load_bg"];
    [self.view addSubview:headerBgView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 110) / 2, 20, 110, 80)];
    logoView.image = [UIImage imageNamed:@"load_logo"];
    [headerBgView addSubview:logoView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 80) / 2, logoView.bottom + 20, 80, 50)];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"小麦芽";
    [headerBgView addSubview:label];
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 210, KScreenWidth, 110)];
    firstView.userInteractionEnabled = YES;
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    NSArray *images = @[@"load_person",@"load_password"];
    NSArray *placerholders = @[@"请输入手机号码",@"请输入密码"];
    
    for (int i = 0; i < images.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 60 * i, KScreenWidth - 40, 50)];
        view.layer.cornerRadius = 15;
        view.layer.borderColor = ButtonLColor.CGColor;
        view.layer.borderWidth = .2;
        view.tag = 10000 + i;
        [firstView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        imageView.image = [UIImage imageNamed:images[i]];
        [view addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, 8, .2, 34)];
        lineView.backgroundColor = GraytextColor;
        [view addSubview:lineView];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.tag = 10010 + i;
        textField.frame = CGRectMake(65, 0, view.width - 65 - 10, 50);
        if (i == 1) {
            textField.secureTextEntry = YES;
        }
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        NSString *lastLoadphone = [userdefaluts objectForKey:wheatMalt_loadPhone];
        if (lastLoadphone != nil && i == 0) {
            textField.text = lastLoadphone;
        }
        
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = SmallFont;
        textField.placeholder = placerholders[i];
        [view addSubview:textField];
    }

    
    UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(20, firstView.bottom + 21, KScreenWidth - 40, 45)];
    loadButton.backgroundColor = ButtonHColor;
    loadButton.clipsToBounds = YES;
    loadButton.layer.cornerRadius = 15;
    [loadButton setTitle:@"登录" forState:UIControlStateNormal];
    loadButton.titleLabel.font = SmallFont;
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [loadButton addTarget:self action:@selector(loadtabAction) forControlEvents:UIControlEventTouchUpInside];
    
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
    
//    UIView *leftLineView = [BasicControls drawLineWithFrame:CGRectMake(30, KScreenHeight - 100 - 64, (KScreenWidth - 150 - 60) / 2, .5)];
//    [self.view addSubview:leftLineView];
//    
//    UIView *rightLineView = [BasicControls drawLineWithFrame:CGRectMake(((KScreenWidth - 150 - 60) / 2) + 30 + 150, KScreenHeight - 100 - 64, (KScreenWidth - 150 - 60) / 2, .5)];
//    [self.view addSubview:rightLineView];
//    
//    UILabel *thirdLoadLabel = [[UILabel alloc] initWithFrame:CGRectMake(((KScreenWidth - 150 - 60) / 2) + 30, KScreenHeight - 115 - 64, 150, 30)];
//    thirdLoadLabel.font = SmallFont;
//    thirdLoadLabel.textColor = commentColor;
//    thirdLoadLabel.textAlignment = NSTextAlignmentCenter;
//    thirdLoadLabel.text = @"第三方登录";
//    [self.view addSubview:thirdLoadLabel];
//
//    
//    UIButton *wechatBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    wechatBT.frame = CGRectMake((KScreenWidth - 40) / 2, KScreenHeight - 80 - 64, 40, 40);
//    [wechatBT setImage:[UIImage imageNamed:@"WeChat"] forState:UIControlStateNormal];
//    [wechatBT addTarget:self action:@selector(wechatLoad) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wechatBT];

}

#pragma mark - 按钮事件
/**
 登录
 */
- (void)loadtabAction
{
    [self.view endEditing:YES];
    
    UIView *phoneBgView = (UIView *)[firstView viewWithTag:10000];
    UITextField *phone = (UITextField *)[phoneBgView viewWithTag:10010];
    UIView *passwordBgView = (UIView *)[firstView viewWithTag:10001];
    UITextField *password = (UITextField *)[passwordBgView viewWithTag:10011];

    if (![BasicControls isMobileNumber:phone.text]) {
        [BasicControls showAlertWithMsg:@"请输入正确的手机号" addTarget:self];
        return;
    }
    
    if (password.text.length == 0) {
        [BasicControls showAlertWithMsg:@"密码不能为空" addTarget:self];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:phone.text forKey:@"phone"];
    [para setObject:password.text forKey:@"pwd"];
    [para setObject:@"app" forKey:@"clientType"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_load params:para Token:NO success:^(id responseObject) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:[responseObject objectForKey:@"tokenid"] forKey:wheatMalt_Tokenid];
        [userdefault setObject:[responseObject objectForKey:@"VO"] forKey:wheatMalt_UserMessage];
        [userdefault setObject:@YES forKey:wheatMalt_isLoading];
        [userdefault setObject:phone.text forKey:wheatMalt_loadPhone];
        [userdefault synchronize];
        
        BaseTabBarController *BaseTabBarVC = [[BaseTabBarController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = BaseTabBarVC;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //获取负责人
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            [paras setObject:[[responseObject objectForKey:@"VO"] valueForKey:@"quyu"] forKey:@"quyu"];
            [HTTPRequestTool requestMothedWithPost:wheatMalt_chragePerson params:paras Token:YES success:^(id responseObject) {
                NSMutableArray *personList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"List"]];
                NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"quyu" ascending:YES]];
                [personList sortUsingDescriptors:sortDescriptors];
                
                [userdefault setObject:personList forKey:wheatMalt_ChargePersonData];
                [userdefault synchronize];
            } failure:^(NSError *error) {
            }  Target:nil];
        });
    } failure:^(NSError *error) {
    } Target:self];
}

/**
 微信登录
 */
- (void)wechatLoad
{
    [self.view endEditing:YES];
    NSLog(@"微信登录");
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

#pragma mark - util
- (UIImage *)createImageWithColor:(UIColor*) color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    if (doublePage == 4) {
        [scrollView removeFromSuperview];
    }
}
@end
