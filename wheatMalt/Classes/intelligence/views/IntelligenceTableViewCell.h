//
//  IntelligenceTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntelligenceTableViewCell : UITableViewCell

{
    UIView *_topView;
    
    UILabel *_todayLabel;
    UILabel *_yearLabel;
    UILabel *_dateLabel;
    
    UILabel *_nameLabel;
    UILabel *_jeLabel;
    UILabel *_stateLabel;
    
    UIImageView *_titleView;
    UILabel *_titleLabel;
    
    UIImageView *_leadView;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
