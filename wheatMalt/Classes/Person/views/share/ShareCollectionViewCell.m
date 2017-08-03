//
//  ShareCollectionViewCell.m
//  wheatMalt
//
//  Created by Apple on 2017/8/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ShareCollectionViewCell.h"

@implementation ShareCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imgaeView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth - 80) / 3, ((KScreenWidth - 80) / 3) * DeviceProportion)];
        [self.contentView addSubview:_imgaeView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [_imgaeView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
    _imgaeView.image = [UIImage imageNamed:[self.dic valueForKey:@"imageName"]];
}

@end
