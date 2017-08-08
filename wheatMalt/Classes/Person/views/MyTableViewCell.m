//
//  MyTableViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

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
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        _headView.clipsToBounds = YES;
        _headView.layer.cornerRadius = 10;
        [self.contentView addSubview:_headView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 28, KScreenWidth - 120, 24)];
        _nameLabel.font = LargeFont;
        [self.contentView addSubview:_nameLabel];
        
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 25, 32.5, 15, 15)];
        [self.contentView addSubview:_leadView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    NSString *userpic = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_100,w_100",[userMessage valueForKey:@"userpic"]];
    [_headView sd_setImageWithURL:[NSURL URLWithString:userpic] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];
    _nameLabel.text = [userMessage valueForKey:@"name"];
    _leadView.image = [UIImage imageNamed:@"lead"];
}
@end
