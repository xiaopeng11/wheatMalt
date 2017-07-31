//
//  CustomerModel.h
//  wheatMalt
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject
/*
 {
 "id":2,
 "gsdm":"",
 "gsname":"中国联通",
 "lxr":"张三",
 "phone":"18662607101",
 "country":"",
 "province":"",
 "city":"",
 "town":"",
 "dz":"",
 "usrid":1,
 "zdrdm":1,
 "zdrq":"2017-07-28 10:12:36",
 "xgrdm":1,
 "xgrq":"2017-07-28 10:12:36",
 "comments":"进期要换系统",
 "status":0,
 "commu":"[]",
 "txflag":1,
 "txdate":"2017-08-01",
 "yxbz":0,
 "isdelete":0
 },
 */

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
@property(nonatomic,strong)NSNumber *xgrdm;
@property(nonatomic,copy)NSString *xgrq;
@property(nonatomic,copy)NSString *comments;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *commu;
@property(nonatomic,strong)NSNumber *txflag;
@property(nonatomic,copy)NSString *txdate;
@property(nonatomic,strong)NSNumber *yxbz;
@property(nonatomic,strong)NSNumber *isdelete;
@property(nonatomic,copy)NSString *zcrq;

@end
