//
//  HomeTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

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
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12.5, 100, 25)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        _leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 15, 20, 20)];
        [self.contentView addSubview:_leaderView];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 49.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.image = [UIImage imageNamed:self.dic[@"imageName"]];
    
    _titleLabel.text = self.dic[@"title"];
    
    _leaderView.image = [UIImage imageNamed:@"lead"];

}

@end
