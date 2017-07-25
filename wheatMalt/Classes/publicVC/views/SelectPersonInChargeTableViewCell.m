//
//  SelectPersonInChargeTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SelectPersonInChargeTableViewCell.h"

@implementation SelectPersonInChargeTableViewCell

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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20 - 30, 20)];
        _nameLabel.font = SmallFont;
        [self.contentView addSubview:_nameLabel];
        
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 50, 7.5, 25, 25)];
        _selectImageView.hidden = YES;
        [self.contentView addSubview:_selectImageView];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 39.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _nameLabel.text = [self.dic valueForKey:self.key];
    
    if ([[self.dic valueForKey:@"select"] integerValue] == 1) {
        _selectImageView.hidden = NO;
        _selectImageView.image = [UIImage imageNamed:@"select"];
    } else {
        _selectImageView.hidden = YES;
    }
}

@end
