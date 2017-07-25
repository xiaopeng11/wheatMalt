//
//  PersonInChargeTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PersonInChargeTableViewCell.h"

@implementation PersonInChargeTableViewCell

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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        [self.contentView addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
        _nameLabel.font = SmallFont;
        [self.contentView addSubview:_nameLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 39.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [self.dic[@"isChoose"] boolValue] ? [UIImage imageNamed:@"isChoose"] : [UIImage imageNamed:@"noChoose"];
    
    _nameLabel.text = self.dic[@"name"];
}

@end
