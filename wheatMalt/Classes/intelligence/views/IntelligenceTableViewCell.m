//
//  IntelligenceTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IntelligenceTableViewCell.h"
#define TitleWidth ((KScreenWidth - 70 - 30 - 60) / 4)
@implementation IntelligenceTableViewCell

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
        
        _todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 24.5, 50, 21)];
        _todayLabel.font = SmallFont;
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.textColor = GraytextColor;
        _todayLabel.hidden = YES;
        [self.contentView addSubview:_todayLabel];
        
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 50, 21)];
        _yearLabel.font = SmallFont;
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.textColor = GraytextColor;
        _yearLabel.hidden = YES;
        [self.contentView addSubview:_yearLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 50, 21)];
        _dateLabel.font = SmallFont;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = GraytextColor;
        _dateLabel.hidden = YES;
        [self.contentView addSubview:_dateLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = LargeFont;
        [self.contentView addSubview:_nameLabel];
        
        _jeLabel = [[UILabel alloc] init];
        _jeLabel.font = LargeFont;
        _jeLabel.textAlignment = NSTextAlignmentRight;
        _jeLabel.textColor = GreenStateColor;
        [self.contentView addSubview:_jeLabel];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = SmallFont;
        _stateLabel.textColor = RedStateColor;
        _stateLabel.hidden = YES;
        [self.contentView addSubview:_stateLabel];
        
        for (int i = 0; i < 3; i++) {
            _titleView = [[UIImageView alloc] init];
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = SmallFont;
            _titleView.tag = 40010 + i;
            _titleLabel.tag = 40020 + i;
            if (i == 0) {
                _titleView.frame = CGRectMake(70, 40, 20, 20);
                _titleLabel.frame = CGRectMake(90, 42, TitleWidth, 21);
            } else if (i == 1){
                _titleView.frame = CGRectMake(90 + TitleWidth, 40, 20, 20);
                _titleLabel.frame = CGRectMake(110 + TitleWidth, 42, TitleWidth * 1.8, 21);
            } else {
                _titleView.frame = CGRectMake(110 + (TitleWidth * 2.8), 40, 20, 20);
                _titleLabel.frame = CGRectMake(130 + (TitleWidth * 2.8), 42, TitleWidth * 1.2, 21);
            }
            [self.contentView addSubview:_titleView];
            [self.contentView addSubview:_titleLabel];
        }
        
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 25, 25, 20, 20)];
        [self.contentView addSubview:_leadView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString *dateString = [self.dic valueForKey:@"zdrq"];
    
    if (dateString.length > 2) {
        _todayLabel.hidden = YES;
        _yearLabel.hidden = NO;
        _dateLabel.hidden = NO;
        _yearLabel.text = [dateString substringToIndex:4];
        _dateLabel.text = [dateString substringWithRange:NSMakeRange(5, 5)];
    } else {
        _yearLabel.hidden = YES;
        _dateLabel.hidden = YES;
        _todayLabel.hidden = NO;
        _todayLabel.text = dateString;
    }
    
    _nameLabel.text = [self.dic valueForKey:@"gsname"];
    
    
    _jeLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"fl"]];
    CGFloat jeWidth = [_jeLabel sizeThatFits:CGSizeMake(0, 30)].width;
    
    if ([[self.dic valueForKey:@"status"] integerValue] == 3) {
        _jeLabel.textColor = GraytextColor;
        _jeLabel.frame = CGRectMake(KScreenWidth - 35 - 110 - jeWidth, 5, jeWidth, 30);
        
        _stateLabel.hidden = NO;
        _stateLabel.frame = CGRectMake(KScreenWidth - 35 - 110, 5, 110, 30);
        _stateLabel.text = @"(未续费已停用)";
        
        _nameLabel.frame = CGRectMake(70, 5, KScreenWidth - 70 - 35 - 110 - jeWidth - 5, 30);
    } else {
        _jeLabel.frame = CGRectMake(KScreenWidth - 35 - jeWidth, 5, jeWidth, 30);
        _nameLabel.frame = CGRectMake(70, 5, KScreenWidth - 70 - 35 - jeWidth - 5, 30);
    }
    
    for (int i = 0; i < 3; i++) {
        _titleView = (UIImageView *)[self.contentView viewWithTag:40010 + i];
        _titleLabel = (UILabel *)[self.contentView viewWithTag:40020 + i];
        if (i == 0) {
            _titleView.image = [UIImage imageNamed:@"kehu"];
            _titleLabel.text = [self.dic valueForKey:@"lxr"];
        } else if (i == 1) {
            _titleView.image = [UIImage imageNamed:@"phone"];
            _titleLabel.text = [self.dic valueForKey:@"phone"];
        } else {
            _titleView.image = [UIImage imageNamed:@"je"];
            _titleLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"je"]];
        }
    }
    
    _leadView.image = [UIImage imageNamed:@"lead"];
}
@end
