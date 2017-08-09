//
//  ChoooseIntelligenceTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoooseIntelligenceTableViewCell.h"

@implementation ChoooseIntelligenceTableViewCell

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
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self.contentView addSubview:_headerImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12.5, KScreenWidth - 80, 25)];
        _titleLabel.font = SmallFont;
        [self.contentView addSubview:_titleLabel];
        
        _leaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 15, 20, 20)];
        [self.contentView addSubview:_leaderImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerImageView.image = [UIImage imageNamed:@"timeRanges"];
    
    _titleLabel.text = @"选择时间";

    _leaderImageView.image = [UIImage imageNamed:@"lead"];

}
@end
