//
//  TouchView.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20)];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.backgroundColor = [UIColor whiteColor];
        self.contentLabel.layer.borderWidth = .5;
        self.contentLabel.layer.cornerRadius = 5;
        self.contentLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.textColor = [UIColor blackColor];
        [self addSubview:self.contentLabel];
        
        self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 19, 0, 20, 20)];
        self.warningLabel.backgroundColor = [UIColor redColor];
        self.warningLabel.textColor = [UIColor whiteColor];
        self.warningLabel.font = [UIFont systemFontOfSize:12];
        self.warningLabel.textAlignment = NSTextAlignmentCenter;
        self.warningLabel.clipsToBounds = YES;
        self.warningLabel.layer.cornerRadius = 10;
        self.warningLabel.hidden = YES;
        [self addSubview:self.warningLabel];
    }
    return self;
}

@end
