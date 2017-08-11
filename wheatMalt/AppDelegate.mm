//
//  AppDelegate.m
//  wheatMalt
//
//  Created by Apple on 2017/6/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AppDelegate.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import "WXApi.h"

#import "LoadingViewController.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //判断是否已经登陆
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    BOOL isloading = [[userdefaults objectForKey:wheatMalt_isLoading] boolValue];
    BOOL isloading = NO;
    if (!isloading) {
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[LoadingViewController alloc] init]];
        //2.设置导航控制器为window的根视图
        self.window.rootViewController = nav;
    } else {
        _window.rootViewController = [[BaseTabBarController alloc] init];
    }
    //刷新登录用户信息
//    [self refreshUserMessage];
    
    //初始化ShareSDK应用
//    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
//        switch (platformType)
//        {
//            case SSDKPlatformTypeWechat:
//                [ShareSDKConnector connectWeChat:[WXApi class]];
//                break;
//            case SSDKPlatformTypeQQ:
//                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                break;
//            default:
//                break;
//        }
//    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//        switch (platformType)
//        {
//            case SSDKPlatformTypeWechat:
//                [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
//                                      appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
//                break;
//            case SSDKPlatformTypeQQ:
//                [appInfo SSDKSetupQQByAppId:@"100371282"
//                                     appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                   authType:SSDKAuthTypeBoth];
//                break;
//            default:
//                break;
//        }
//    }];
    
    return YES;
}

#pragma mark - 刷新登录用户数据
- (void)refreshUserMessage
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaults objectForKey:wheatMalt_UserMessage];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@",[userMessage valueForKey:@"id"]] forKey:@"id"];
    
    [HTTPRequestTool requestMothedWithPost:wheatMalt_RefreshUserMessage params:params Token:YES success:^(id responseObject) {
        NSDictionary *userMessage = responseObject[@"VO"];
        if ([[userMessage objectForKey:@"isdelete"] intValue] == 1) {
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已被移除" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [userdefaults setObject:@NO forKey:wheatMalt_isLoading];
                [userdefaults removeObjectForKey:wheatMalt_Tokenid];
                [userdefaults synchronize];
                BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[LoadingViewController alloc] init]];
                self.window.rootViewController = nav;
            }];
            
            [alertcontroller addAction:okaction];
            
        }
    } failure:^(NSError *error) {
        
    } Target:nil];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
