//
//  PersonTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell

{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_warningLabel;
    UIImageView *_leadView;
    UIView *_lineView;
}
@property(nonatomic,strong)NSDictionary *dic;
@end
