//
//  TouchView.h
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchView : UIView

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *excontentLabel;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end
