//
//  PersonTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

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
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 13, 100, 24)];
        _titleLabel.font = SmallFont;
        [self.contentView addSubview:_titleLabel];
        
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 15, 20, 20)];
        [self.contentView addSubview:_leadView];
        
        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 60, 10, 30, 30)];
        _warningLabel.font = SmallFont;
        _warningLabel.backgroundColor = RedStateColor;
        _warningLabel.textColor = [UIColor whiteColor];
        _warningLabel.hidden = YES;
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.clipsToBounds = YES;
        _warningLabel.layer.cornerRadius = 15;
        [self.contentView addSubview:_warningLabel];
        
        _lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 49.5, KScreenWidth, .5)];
        _lineView.hidden = YES;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.image = [UIImage imageNamed:[self.dic valueForKey:@"imageName"]];
    
    _titleLabel.text = [self.dic valueForKey:@"name"];
    
    if ([self.dic.allKeys containsObject:@"warning"]) {
        _warningLabel.hidden = NO;
        if ([[self.dic valueForKey:@"warning"] integerValue] > 99) {
            _warningLabel.text = @"99+";
        } else {
            _warningLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"warning"]];
        }
    } else {
        _warningLabel.hidden = YES;
    }
    
    _leadView.image = [UIImage imageNamed:@"lead"];
    
    if ([self.dic.allKeys containsObject:@"showLine"]) {
        _lineView.hidden = NO;
    } else {
        _lineView.hidden = YES;
    }
}
@end
