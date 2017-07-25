//
//  PendingPersonsTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PendingPersonsTableViewCell.h"

@implementation PendingPersonsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 100, 24)];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 13, KScreenWidth - 160, 24)];
        [self.contentView addSubview:_phoneLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 50, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _nameLabel.text = [self.dic valueForKey:@"name"];
    _phoneLabel.text = [self.dic valueForKey:@"phone"];
}

@end
