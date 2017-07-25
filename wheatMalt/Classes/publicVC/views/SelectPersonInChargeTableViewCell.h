//
//  SelectPersonInChargeTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPersonInChargeTableViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    UIImageView *_selectImageView;
}

@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,copy)NSString *key;
@end
