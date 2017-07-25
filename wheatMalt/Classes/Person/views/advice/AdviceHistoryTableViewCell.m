//
//  AdviceHistoryTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AdviceHistoryTableViewCell.h"

@implementation AdviceHistoryTableViewCell

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
        _adviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, KScreenWidth - 40, 30)];
        _adviceLabel.font = LargeFont;
        [self.contentView addSubview:_adviceLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, KScreenWidth - 120, 20)];
        _timeLabel.font = SmallFont;
        _timeLabel.textColor = GraytextColor;
        [self.contentView addSubview:_timeLabel];
        
        _lxLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 110, 55, 80, 20)];
        _lxLabel.textAlignment = NSTextAlignmentRight;
        _lxLabel.font = SmallFont;
        _lxLabel.textColor = RedStateColor;
        [self.contentView addSubview:_lxLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 89.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adviceLabel.text = [self.dic valueForKey:@"advice"];
    _timeLabel.text = [self.dic valueForKey:@"time"];
    if ([[self.dic valueForKey:@"lx"] isEqualToString:@"1"]) {
        _lxLabel.text = @"违规举报";
    }
}
@end
