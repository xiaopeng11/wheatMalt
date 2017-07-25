//
//  MyTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

{
    UIImageView *_headView;
    UILabel *_nameLabel;
    UIImageView *_leadView;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
