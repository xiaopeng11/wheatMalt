//
//  BugDetailsTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BugDetailsTableViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_numLabel;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
