//
//  ChannelUnitModel.h
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelUnitModel : NSObject
@property (nonatomic, copy) NSString *cid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger isTop;

@property (nonatomic, assign) double Rebate;

@property (nonatomic, copy)NSArray *qqlist;

@end
