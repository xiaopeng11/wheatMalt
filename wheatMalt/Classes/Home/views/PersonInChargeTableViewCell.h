//
//  PersonInChargeTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInChargeTableViewCell : UITableViewCell
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
}
@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,strong)NSString *key;

@end
