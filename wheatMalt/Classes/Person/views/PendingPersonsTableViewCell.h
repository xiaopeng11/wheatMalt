//
//  PendingPersonsTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingPersonsTableViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
