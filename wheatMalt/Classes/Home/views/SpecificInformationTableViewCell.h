//
//  SpecificInformationTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecificInformationTableViewCell : UITableViewCell
{
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    UILabel *_lxLable;
    
}
@property(nonatomic,copy)NSDictionary *dic;
@end
