//
//  HomeTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIImageView *_leaderView;
}
@property(nonatomic,copy)NSDictionary *dic;
@end
