//
//  CustomerTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomerTableViewCell.h"
#define lxrWidth ((KScreenWidth - 60 - 30 - 60) / 3)
@implementation CustomerTableViewCell

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
        
        _lxImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lxImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = LargeFont;
        [self.contentView addSubview:_nameLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.font = SmallFont;
        [self.contentView addSubview:_stateLabel];
        
        _lxrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lxrLabel.font = SmallFont;
        _lxrLabel.textColor = GraytextColor;
        [self.contentView addSubview:_lxrLabel];
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneLabel.font = SmallFont;
        _phoneLabel.textColor = GraytextColor;
        [self.contentView addSubview:_phoneLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font = SmallFont;
        _commentLabel.textColor = GraytextColor;
        [self.contentView addSubview:_commentLabel];
        
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_showImageView];
        
        _showLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _showLabel.font = SmallFont;
        _showLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_showLabel];
        
        _leaderView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_leaderView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger index = [[self.dic valueForKey:@"status"] integerValue];
    
    _lxImageView.frame = CGRectMake(10, 25, 40, 40);
    
    if ([[self.dic valueForKey:@"yxbz"] intValue] == 0) {
        if ([[self.dic valueForKey:@"txflag"] intValue] == 1) {
            _lxImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customer_%ld",(long)index]];
        } else {
            _lxImageView.image = [UIImage imageNamed:@"customer_4"];
        }
    } else {
        _lxImageView.image = [UIImage imageNamed:@"customer_5"];
    }
    
    
    _nameLabel.text = [self.dic valueForKey:@"gsname"];
    CGFloat nameWidth = [_nameLabel sizeThatFits:CGSizeMake(0, 30)].width;
    if (nameWidth > KScreenWidth - 60 - 30 - 60 - 70) {
        nameWidth = KScreenWidth - 60 - 30 - 60 - 70;
    }
    _nameLabel.frame = CGRectMake(60, 5, nameWidth, 30);
    
    _stateLabel.frame = CGRectMake(_nameLabel.right, 10, 70, 25);
    if ([[self.dic valueForKey:@"yxbz"] intValue] == 0) {
        if ([[self.dic valueForKey:@"txflag"] intValue] == 1) {
            if (index < 3) {
                _stateLabel.textColor = RedStateColor;
            } else {
                _stateLabel.textColor = GreenStateColor;
            }
            _stateLabel.text = [NSString stringWithFormat:@"%@",customerState[index]];
        } else {
            _stateLabel.textColor = GraytextColor;
            _stateLabel.text = @"(未开启)";
        }

    } else {
        _stateLabel.textColor = [UIColor blackColor];
        _stateLabel.text = @"(已失效)";
    }
    
    _lxrLabel.frame = CGRectMake(60, 35, lxrWidth, 25);
    _lxrLabel.text = [self.dic valueForKey:@"lxr"];
    
    _phoneLabel.frame = CGRectMake(60 + lxrWidth, 35, lxrWidth * 2, 25);
    _phoneLabel.text = [self.dic valueForKey:@"phone"];
    
    _commentLabel.frame = CGRectMake(60, 35 + 25, KScreenWidth - 150, 25);
    _commentLabel.text = [self.dic valueForKey:@"comments"];
    
    _showImageView.frame = CGRectMake(KScreenWidth - 70, 17, 30, 30);
    _showLabel.frame = CGRectMake(KScreenWidth - 85, _showImageView.bottom + 3, 60, 26);
    if ([[self.dic valueForKey:@"yxbz"] intValue] == 0) {
        if ([[self.dic valueForKey:@"txflag"] intValue] == 1) {
            _showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customer_state_%ld",(long)index]];
            _showLabel.text = [NSString stringWithFormat:@"%@",customerState[index]];
        } else {
            _showImageView.image = [UIImage imageNamed:@"customer_state_4"];
            _showLabel.text = @"未开启";
        }
    } else {
        _showImageView.image = [UIImage imageNamed:@"customer_state_5"];
        _showLabel.text = @"已失效";
    }
    
    _leaderView.frame = CGRectMake(KScreenWidth - 30, 35, 20, 20);
    _leaderView.image = [UIImage imageNamed:@"lead"];
}
@end
