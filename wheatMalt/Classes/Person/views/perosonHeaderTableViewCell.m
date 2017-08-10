//
//  perosonHeaderTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "perosonHeaderTableViewCell.h"

#import "ProfitViewController.h"
#define personHeaderWidth (KScreenWidth - 20)
@implementation perosonHeaderTableViewCell

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
        self.contentView.userInteractionEnabled = YES;
        
        self.contentView.backgroundColor = BaseBgColor;
        
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        _bgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgView];
        
        for (int i = 0; i < 3; i++) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = SmallFont;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.tag = 51000 + i;
            _titleLabel.textColor = [UIColor whiteColor];
            
            _moneyBT = [UIButton buttonWithType:UIButtonTypeCustom];
            _moneyBT.titleLabel.font = [UIFont systemFontOfSize:20];
            _moneyBT.tag = 51010 + i;
            [_moneyBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_moneyBT addTarget:self action:@selector(moenyClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_bgView addSubview:_moneyBT];
            [_bgView addSubview:_titleLabel];
        }
        
        _hiddenJEBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hiddenJEBT addTarget:self action:@selector(hiddenMoeny) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_hiddenJEBT];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgView.image = [UIImage imageNamed:@"person_headbg"];
    NSArray *titles = @[@"总收益",@"待结算收益",@"已结算收益"];
    for (int i = 0; i < 3; i++) {
        _titleLabel = (UILabel *)[self.contentView viewWithTag:51000 + i];
        _moneyBT = (UIButton *)[self.contentView viewWithTag:51010 + i];
        _titleLabel.text = titles[i];
        CGFloat width = [_titleLabel sizeThatFits:CGSizeMake(0, 30)].width;
        if (i == 0) {
            _titleLabel.frame = CGRectMake((personHeaderWidth - width) / 2, 20, width, 30);
            _moneyBT.frame = CGRectMake(0, 50, personHeaderWidth, 40);
            _hiddenJEBT.frame = CGRectMake((personHeaderWidth / 2) + width + 10, 25, 25, 25);
        } else {
            _titleLabel.frame = CGRectMake((((personHeaderWidth - .5) / 2) * (i - 1)) + .5, 120, (KScreenWidth - .5) / 2, 30);
            _moneyBT.frame = CGRectMake((((personHeaderWidth - .5) / 2) * (i - 1)) + .5, 150, (KScreenWidth - .5) / 2, 40);
        }
        
        if ([[self.dic valueForKey:@"hideJE"] isEqualToString:@"0"]) {
            NSString *money = [NSString stringWithFormat:@"%@",[self.dic valueForKey:titles[i]]];
            [_moneyBT setTitle:[NSString stringWithFormat:@"￥%@",[money FormatPriceWithPriceString]] forState:UIControlStateNormal];
        } else {
            _moneyBT = (UIButton *)[self.contentView viewWithTag:51010 + i];
            [_moneyBT setTitle:@"***" forState:UIControlStateNormal];
        }
    }
    
    
    if ([[self.dic valueForKey:@"hideJE"] isEqualToString:@"1"]) {
        [_hiddenJEBT setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    } else {
        [_hiddenJEBT setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
}

- (void)moenyClick:(UIButton *)button
{
    ProfitViewController *ProfitVC = [[ProfitViewController alloc] init];
    if (button.tag == 51010) {
        ProfitVC.lx = @"0";
    } else if (button.tag == 51011) {
        ProfitVC.lx = @"1";
    } else if (button.tag == 51012) {
        ProfitVC.lx = @"2";
    }
    [self.ViewController.navigationController pushViewController:ProfitVC animated:YES];
}

- (void)hiddenMoeny
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideJE" object:nil];
}
@end
