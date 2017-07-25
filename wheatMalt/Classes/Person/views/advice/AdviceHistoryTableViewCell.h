//
//  AdviceHistoryTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviceHistoryTableViewCell : UITableViewCell
{
    UILabel *_adviceLabel;
    UILabel *_timeLabel;
    UILabel *_lxLabel;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
