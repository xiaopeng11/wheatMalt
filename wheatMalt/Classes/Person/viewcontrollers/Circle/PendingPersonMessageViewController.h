//
//  PendingPersonMessageViewController.h
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "TouchView.h"
@interface PendingPersonMessageViewController : BaseViewController

@property(nonatomic,copy)NSDictionary *personMessage;
@property(nonatomic,strong)TouchView *touchView;
@end
