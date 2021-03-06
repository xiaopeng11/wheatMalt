//
//  HTTPRequestTool.h
//  wheatMalt
//
//  Created by Apple on 2017/6/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestTool : NSObject
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
                       Target:(id)target;
/**
 *  上传数据
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
//http://192.168.1.199:8080/test44/msg/msgAction_getAppMsg.action

//+ (void)reloadMothedWithPost:(NSString *)url
//                      params:(NSDictionary *)params
//                     success:(void (^)(id responseObject))success
//                     failure:(void (^)(NSError *error))failure;
@end
