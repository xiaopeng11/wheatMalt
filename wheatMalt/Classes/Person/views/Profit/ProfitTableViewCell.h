//
//  ProfitTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitTableViewCell : UITableViewCell
{
    UILabel *_dateLabel;
    UILabel *_moneyLabel;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
