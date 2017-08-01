//
//  BatchOperationTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BatchOperationTableViewCell.h"

@implementation BatchOperationTableViewCell

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
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        [self.contentView addSubview:_selectImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = SmallFont;
        [self.contentView addSubview:_titleLabel];
        
        _lxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lxLabel.font = SmallFont;
        [self.contentView addSubview:_lxLabel];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 39.5, KScreenWidth, .5)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _selectImageView.image = [self.dic[@"isChoose"] integerValue] == 1 ? [UIImage imageNamed:@"isChoose"] : [UIImage imageNamed:@"noChoose"];
    
    _titleLabel.text = [self.dic valueForKey:@"gsname"];
    CGFloat titlewidth = [_titleLabel sizeThatFits:CGSizeMake(0, 30)].width;
    _titleLabel.frame = CGRectMake(60, 5, titlewidth, 30);
    
    NSInteger lx = [self.dic[@"status"] integerValue];
    if ([[self.dic allKeys] containsObject:@"enddate"]) {
        if ([self.dic[@"yxbz"] integerValue] == 0) {
            if ([self.dic[@"txflag"] integerValue] == 1) {
                _lxLabel.text = [NSString stringWithFormat:@"(%@)",intelligenceState[lx]];
                _lxLabel.textColor = intelligenceStateColor[lx];
            } else {
                _lxLabel.text = [NSString stringWithFormat:@"(%@)",intelligenceState[4]];
                _lxLabel.textColor = intelligenceStateColor[4];
            }
        } else {
            _lxLabel.text = [NSString stringWithFormat:@"(%@)",intelligenceState[5]];
            _lxLabel.textColor = intelligenceStateColor[5];
        }
    } else {
        _lxLabel.text = [NSString stringWithFormat:@"(%@)",customerState[lx]];
        _lxLabel.textColor = customerStateColor[lx];
    }
    CGFloat lxwidth = [_lxLabel sizeThatFits:CGSizeMake(0, 30)].width;
    _lxLabel.frame = CGRectMake(_titleLabel.right, 5, lxwidth, 30);

}



@end
