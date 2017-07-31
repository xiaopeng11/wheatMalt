//
//  PersonInChargeModel.m
//  wheatMalt
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PersonInChargeModel.h"

@implementation PersonInChargeModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"chargePersonID":@"id"};
}
@end
