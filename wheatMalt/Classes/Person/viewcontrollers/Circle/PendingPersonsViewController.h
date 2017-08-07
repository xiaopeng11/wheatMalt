//
//  PendingPersonsViewController.h
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "TouchView.h"
@interface PendingPersonsViewController : BaseViewController


/**
 * @b 选中某一个频道回调
 */
@property (nonatomic, copy) void(^chooseIndexBlock)(NSDictionary *dic);
@property(nonatomic,copy)NSString *quyu;

@property(nonatomic,strong)NSMutableArray *pendingList;

@property(nonatomic,strong)TouchView *touchView;
@end
