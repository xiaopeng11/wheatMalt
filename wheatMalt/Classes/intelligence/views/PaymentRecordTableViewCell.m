//
//  PaymentRecordTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PaymentRecordTableViewCell.h"

@implementation PaymentRecordTableViewCell

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
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        _dateLabel.font = SmallFont;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dateLabel];
        
        UIView *view1 = [BasicControls drawLineWithFrame:CGRectMake(120, 0, .5, 40)];
        [self.contentView addSubview:view1];
        
        _jeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.5, 0, (KScreenWidth - 121) / 2, 40)];
        _jeLabel.font = SmallFont;
        _jeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_jeLabel];
        
        UIView *view2 = [BasicControls drawLineWithFrame:CGRectMake(120.5 + (KScreenWidth - 121) / 2, 0, .5, 40)];
        [self.contentView addSubview:view2];
        
        _flLabel = [[UILabel alloc] initWithFrame:CGRectMake(121 + ((KScreenWidth - 121) / 2), 0, (KScreenWidth - 121) / 2, 40)];
        _flLabel.font = SmallFont;
        _flLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_flLabel];
        
        UIView *view3 = [BasicControls drawLineWithFrame:CGRectMake(0, 40.5, KScreenWidth, .5)];
        [self.contentView addSubview:view3];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dateLabel.text = [self.dic valueForKey:@"fsrq"];
    _jeLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"je"]];
    if ([[self.dic valueForKey:@"jsbz"] intValue] == 0) {
        _flLabel.textColor = WarningStateColor;
        _flLabel.text = [NSString stringWithFormat:@"%@(未结算)",[self.dic valueForKey:@"flje"]];
    } else {
        _flLabel.textColor = GreenStateColor;
        _flLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"flje"]];
    }
}

@end
