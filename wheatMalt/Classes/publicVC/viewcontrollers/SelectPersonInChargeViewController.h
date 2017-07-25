//
//  SelectPersonInChargeViewController.h
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"


@interface SelectPersonInChargeViewController : BaseViewController

@property(nonatomic,strong)NSDictionary *personInCharge;
@property(nonatomic,strong)NSArray *datalist;
@property(nonatomic,copy)NSString *key;

@property(nonatomic,assign)BOOL canConsloe;  //能够取消选择

@property (nonatomic, copy) void(^changePersnInCharge)(NSDictionary *personMesage);

@end
