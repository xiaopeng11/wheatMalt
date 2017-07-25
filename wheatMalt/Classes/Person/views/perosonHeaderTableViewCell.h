//
//  perosonHeaderTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface perosonHeaderTableViewCell : UITableViewCell

{
    UIView *_bgView;
    UILabel *_titleLabel;
    UIButton *_moneyBT;
    UIButton *_hiddenJEBT;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
