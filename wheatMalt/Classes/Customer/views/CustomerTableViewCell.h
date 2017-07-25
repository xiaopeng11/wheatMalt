//
//  CustomerTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTableViewCell : UITableViewCell

{
    UIView *_topView;
    
    UIImageView *_lxImageView;
    UILabel *_nameLabel;
    UILabel *_stateLabel;
    UILabel *_lxrLabel;
    UILabel *_phoneLabel;
    UILabel *_commentLabel;
    
    UIImageView *_showImageView;
    UILabel *_showLabel;
    
    UIImageView *_leaderView;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
