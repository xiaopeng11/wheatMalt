//
//  BugDetailsTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BugDetailsTableViewCell.h"

@implementation BugDetailsTableViewCell

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
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
        _nameLabel.font = SmallFont;
        [self.contentView addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, KScreenWidth - 150, 30)];
        _numLabel.font = SmallFont;
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = GreenStateColor;
        [self.contentView addSubview:_numLabel];
        
        UIView *view1 = [BasicControls drawLineWithFrame:CGRectMake(0, 0, 49.5, .5)];
        [self.contentView addSubview:view1];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLabel.text = [self.dic valueForKey:@"gwname"];
    _numLabel.text = [NSString stringWithFormat:@"%@",[self.dic valueForKey:@"cnumber"]];
}

@end
