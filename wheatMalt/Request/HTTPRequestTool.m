//
//  HTTPRequestTool.m
//  wheatMalt
//
//  Created by Apple on 2017/6/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HTTPRequestTool.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "LoadingViewController.h"
@implementation HTTPRequestTool
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param token 是否添加token（默认不添加）
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param target 页面对象
 */

+ (void)requestMothedWithPost:(NSString *)url
                       params:(NSDictionary *)params
                        Token:(BOOL)token
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
                       Target:(id)target

{
    //获得请求管理者
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];//请求

    requestManager.requestSerializer.timeoutInterval = 10;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (token == YES) {
        NSString *tokenid = [userDefaults objectForKey:wheatMalt_Tokenid];
        [requestManager.requestSerializer setValue:tokenid forHTTPHeaderField:@"token"];
    }
    if (target != nil) {
        [target showProgress];
    }
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //发送POST请求
    [requestManager POST:[url ChangeInterfaceHeader] parameters:params success:^(AFHTTPRequestOperation                                                                                                                                                                                                                                                                                                                          *operation, id responseObject) {
        if (success) {
            if (target != nil) {
                [target hideProgress];
            }
            if ([responseObject[@"result"] isEqualToString:@"ok"]) {
                success(responseObject);
            } else {
                if ([responseObject[@"message"] isEqualToString:@"timeout"]) {
                    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录超时！请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [userDefaults setObject:@NO forKey:wheatMalt_isLoading];
                        [userDefaults removeObjectForKey:wheatMalt_Tokenid];
                        [userDefaults removeObjectForKey:wheatMalt_UserMessage];
                        [userDefaults synchronize];
                        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[LoadingViewController alloc] init]];
                        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    }];
                    [alertcontroller addAction:okaction];
                    [target presentViewController:alertcontroller animated:YES completion:nil];

                } else {
                    [BasicControls showAlertWithMsg:responseObject[@"message"] addTarget:nil];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            if (target != nil) {
                [target hideProgress];
            }
            failure(error);
            NSLog(@"%@",error);
        }
    }];
}




/**
 *  上传数据
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
//http://192.168.1.199:8080/test44/msg/msgAction_getAppMsg.action

+ (void)reloadMothedWithPost:(NSString *)url
                      params:(NSDictionary *)params
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    //封装字典
    NSMutableDictionary *diced = [NSMutableDictionary dictionary];
    [diced setObject:params forKey:@"vo"];
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:diced options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    [dics setObject:string forKey:@"postdata"];
    
    
    //获得请求管理者
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    // 设置cookie
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    requestManager.requestSerializer.timeoutInterval = 10;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *cookiedata = [userDefaults objectForKey:X6_Cookie];
    
//    if (cookiedata.length) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiedata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    }
    // 加上这行代码，https ssl 验证。
    //    [requestManager setSecurityPolicy:[XPHTTPRequestTool customSecurityPolicy]];
    //发送POST请求
    [requestManager POST:url parameters:dics success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            if ([responseObject[@"type"] isEqualToString:@"success"]) {
                success(responseObject);
//                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//                [userdefaults setObject:data forKey:X6_Cookie];
                [userDefaults synchronize];
            } else {
                [BasicControls showAlertWithMsg:responseObject[@"message"] addTarget:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
