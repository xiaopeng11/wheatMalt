//
//  MessageSettingTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MessageSettingTableViewCell.h"

@implementation MessageSettingTableViewCell

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
        
        self.contentView.userInteractionEnabled = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, KScreenWidth - 100, 24)];
        _titleLabel.font = SmallFont;
        [self.contentView addSubview:_titleLabel];
        
        _openBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBT.frame = CGRectMake(KScreenWidth - 90, 5, 70, 40);
        _openBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _openBT.hidden = YES;
        _openBT.titleLabel.font = SmallFont;
        [_openBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_openBT addTarget:self action:@selector(openRecordorSettingTime) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_openBT];
        
        
        _lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 49.5, KScreenWidth, .5)];
        _lineView.hidden = YES;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.text = [self.dic valueForKey:@"title"];
    
    if ([self.dic.allKeys containsObject:@"isOpen"]) {
        _openBT.hidden = NO;
        if ([[self.dic valueForKey:@"isOpen"] isEqualToString:@"1"]) {
            [_openBT setImage:[UIImage imageNamed:@"button_open"] forState:UIControlStateNormal];
        } else {
            [_openBT setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
        }
    } else {
        if ([self.dic.allKeys containsObject:@"time"]) {
            _openBT.hidden = NO;
            [_openBT setTitle:[self.dic valueForKey:@"time"] forState:UIControlStateNormal];
        } else {
            _openBT.hidden = YES;
        }
    }
    
    
    if ([self.dic.allKeys containsObject:@"showline"]) {
        _lineView.hidden = NO;
    } else {
        _lineView.hidden = YES;
    }
}

- (void)openRecordorSettingTime
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageSetting" object:self.dic];
}
@end
