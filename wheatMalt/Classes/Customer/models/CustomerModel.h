//
//  CustomerModel.h
//  wheatMalt
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject

@property(nonatomic,strong)NSNumber *customerID;
@property(nonatomic,copy)NSString *gsdm;
@property(nonatomic,copy)NSString *gsname;
@property(nonatomic,copy)NSString *lxr;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *town;
@property(nonatomic,copy)NSString *dz;
@property(nonatomic,strong)NSNumber *usrid;
@property(nonatomic,strong)NSNumber *mdgs;
@property(nonatomic,copy)NSString *usrname;
@property(nonatomic,strong)NSNumber *zdrdm;
@property(nonatomic,copy)NSString *zdrq;
@property(nonatomic,copy)NSString *comments;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)NSNumber *txflag;
@property(nonatomic,copy)NSString *txdate;
@property(nonatomic,strong)NSNumber *yxbz;
@property(nonatomic,strong)NSNumber *isdelete;
@property(nonatomic,copy)NSString *zcrq;

@end
