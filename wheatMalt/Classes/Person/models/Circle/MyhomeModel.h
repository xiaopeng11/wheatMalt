//
//  MyhomeModel.h
//  wheatMalt
//
//  Created by 肖鹏 on 2017/8/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyhomeModel : NSObject
@property(nonatomic,copy)NSString *fullname;       //区域路径
@property(nonatomic,copy)NSString *szm;       //
@property(nonatomic,copy)NSString *name;       //区域名称
@property(nonatomic,strong)NSNumber *fd;//返利点数
@property(nonatomic,strong)NSNumber *fzrdm;//负责人代码
@property(nonatomic,copy)NSString *fzrname;//负责人名称
@property(nonatomic,strong)NSNumber *sqrs;//申请人数
@property(nonatomic,strong)NSArray *sqList;//申请人列表

@end
