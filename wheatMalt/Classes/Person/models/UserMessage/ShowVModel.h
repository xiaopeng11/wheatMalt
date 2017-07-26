//
//  ShowVModel.h
//  wheatMalt
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowVModel : NSObject

@property(nonatomic,strong)NSNumber *endv;    //上限
@property(nonatomic,copy)NSString *Vid;       //id
@property(nonatomic,strong)NSNumber *isdelete;//删除
@property(nonatomic,copy)NSString *name;      //等级
@property(nonatomic,copy)NSString *sortid;    //类型
@property(nonatomic,strong)NSNumber *startv;  //下限
@property(nonatomic,copy)NSString *zwName;    //职务名称
@property(nonatomic,strong)NSNumber *zwid;    //职务id

@end
