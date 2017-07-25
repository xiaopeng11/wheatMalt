//
//  PaymentRecordTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentRecordTableViewCell : UITableViewCell
{
    UILabel *_dateLabel;
    UILabel *_jeLabel;
    UILabel *_flLabel;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
