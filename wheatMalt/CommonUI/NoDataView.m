//
//  NoDataView.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NoDataView.h"
@interface NoDataView()
{
    UIImageView *_imageview;
    UILabel *_label;
}
@end
@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - (215 / 3.0)) / 2.0, 10, 215 / 3.0, 229/ 3.0)];
        _imageview.image = [UIImage imageNamed:@"nodataimage"];
        [self addSubview:_imageview];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageview.bottom + 10, KScreenWidth, 50)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = _showPlacerHolder;
        _label.textColor = [UIColor grayColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)setShowPlacerHolder:(NSString *)showPlacerHolder
{
    if (_showPlacerHolder != showPlacerHolder) {
        _showPlacerHolder = showPlacerHolder;
        _label.text = _showPlacerHolder;
    }
}

@end
