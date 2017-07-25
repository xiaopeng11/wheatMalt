//
//  ProfitTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ProfitTableViewCell.h"

@implementation ProfitTableViewCell

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
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, (KScreenWidth - 20) / 2, 24)];
        _dateLabel.font = SmallFont;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dateLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ((KScreenWidth - 20) / 2), 13, (KScreenWidth - 20) / 2, 24)];
        _moneyLabel.font = SmallFont;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_moneyLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 0, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _dateLabel.text = [self.dic valueForKey:@"date"];
    NSString *moeny = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"money"]];
    if ([[self.dic valueForKey:@"lx"] integerValue] == 1) {
        _moneyLabel.textColor = WarningStateColor;
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@(未结算)",[moeny FormatPriceWithPriceString]];
    } else {
        _moneyLabel.textColor = GreenStateColor;
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[moeny FormatPriceWithPriceString]];
    }
}
@end
