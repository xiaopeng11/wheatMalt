//
//  BatchOperationTableViewCell.h
//  wheatMalt
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatchOperationTableViewCell : UITableViewCell
{
    UIImageView *_selectImageView;
    UILabel *_titleLabel;
    UILabel *_lxLabel;
}
@property(nonatomic,strong)NSDictionary *dic;

@end
