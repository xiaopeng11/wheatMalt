//
//  MessageSettingTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSettingTableViewCell : UITableViewCell
{
    UILabel *_titleLabel;
    UIButton *_openBT;

    UIView *_lineView;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
