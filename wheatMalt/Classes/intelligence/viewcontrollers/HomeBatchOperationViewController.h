//
//  HomeBatchOperationViewController.h
//  wheatMalt
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeBatchOperationViewController : BaseViewController

@property(nonatomic,strong)NSMutableDictionary *paras;  //搜索条件

@property(nonatomic,assign)BOOL customer;               //是情报

@property(nonatomic,strong)NSMutableArray *Exitdatalist;       //已有数据

@property(nonatomic,assign)int page;  //当前页数
@property(nonatomic,assign)int pages;  //总页数

@property(nonatomic,copy)NSString *searchURL;  //搜索的接口

@end
