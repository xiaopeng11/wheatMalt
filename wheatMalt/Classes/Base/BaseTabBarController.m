//
//  BaseTabBarController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseTabBarController.h"

#import "CropViewController.h"
#import "CustomerViewController.h"
#import "HomeViewController.h"
#import "IntelligenceViewController.h"
#import "PersonViewController.h"

#import "BaseNavigationController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建tabbar
    [self initTabBarView];
    
    //网络获取版本
    [self isNetworkNewVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化子视图
    [self initViewControllers];
}


//网络获取版本
- (void)isNetworkNewVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersionString = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSArray *array = [appVersionString componentsSeparatedByString:@"."];
    NSString *appVersion = [NSString stringWithFormat:@"%@%@",array[1],array[2]];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    //发送POST请求
    [requestManager POST:APP_URL parameters:nil success:^(AFHTTPRequestOperation                                                                                                                                                                                                                                                                                                                          *operation, id responseObject) {
        NSArray *infoArray = [responseObject objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseinfo = [infoArray objectAtIndex:0];
            NSString *lastVersionSting = [releaseinfo objectForKey:@"version"];
            NSArray *arrayed = [lastVersionSting componentsSeparatedByString:@"."];
            NSString *lastVersion = [NSString stringWithFormat:@"%@%@",arrayed[1],arrayed[2]];
            if ([lastVersion longLongValue] > [appVersion longLongValue]) {
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"有新的版本更新，是否前往更新？" message:[releaseinfo valueForKey:@"releaseNotes"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:[releaseinfo objectForKey:@"trackViewUrl"]];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                [alertcontroller addAction:cancelaction];
                [alertcontroller addAction:okaction];
                [self presentViewController:alertcontroller animated:YES completion:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}



/**
 创建自定义tabbar
 */
- (void)initTabBarView
{
    //创建tabbar
    _customTabBar = [[UITabBar alloc] init];
    
    //    更换系统的tabbar
    [self setValue:_customTabBar forKeyPath:@"tabBar"];
    
}

/**
 初始化所有的子控制器
 */
- (void)initViewControllers
{
    //吐槽
    CropViewController *cropVC = [[CropViewController alloc] init];
    [self addOneChildVC:cropVC title:@"吐槽" selectedImageName:@"tabbar_tucao_h" unselectedImageName:@"tabbar_tucao_l"];
    
    //情报
    CustomerViewController *customerVC = [[CustomerViewController alloc] init];
    [self addOneChildVC:customerVC title:@"情报" selectedImageName:@"tabbar_qingbao_h" unselectedImageName:@"tabbar_qingbao_l"];
    
    //麦田

    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addOneChildVC:homeVC title:@"麦田" selectedImageName:@"tabbar_maitian_h" unselectedImageName:@"tabbar_maitian_l"];
    
    //客户
    IntelligenceViewController *intelligenceVC = [[IntelligenceViewController alloc] init];
    [self addOneChildVC:intelligenceVC title:@"客户" selectedImageName:@"tabbar_kehu_h" unselectedImageName:@"tabbar_kehu_l"];
    
    //我
    PersonViewController *personVC = [[PersonViewController alloc] init];
    [self addOneChildVC:personVC title:@"我" selectedImageName:@"tabbar_me_h" unselectedImageName:@"tabbar_me_l"];
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVC             子控制器对象
 *  @param title               标题
 *  @param selectedImageName   图标
 *  @param unselectedImageName 选中的图标
 */
- (void)addOneChildVC:(UIViewController *)childVC
                title:(NSString *)title
    selectedImageName:(NSString *)selectedImageName
  unselectedImageName:(NSString *)unselectedImageName
{
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    UIImage *unselectedImage = [UIImage imageNamed:unselectedImageName];
    if (iOS7) {
        //如果是iOS7以上的系统，取消自动渲染效果
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:title image:unselectedImage selectedImage:selectedImage];
    
    barItem.title = title;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ButtonLColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ButtonHColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    childVC.tabBarItem = barItem;
    
    //添加tabbar控制器的字控制器
    BaseNavigationController *naviVC = [[BaseNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:naviVC];
}


@end
