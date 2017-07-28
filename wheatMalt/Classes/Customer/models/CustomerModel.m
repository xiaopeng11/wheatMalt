//
//  CustomerModel.m
//  wheatMalt
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"customerID":@"id"};
}
@end
