//
//  NoDataView.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView


- (instancetype)initWithFrame:(CGRect)frame
                         type:(PlaceholderViewType)type
                     delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        // 存值
        _delegate = delegate;
        // UI搭建
        self.backgroundColor = BaseBgColor;
        
        //------- 图片在正中间 -------//
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 50, (self.frame.size.height - 160) / 2, 100, 100)];
        [self addSubview:imageView];
        
        //------- 说明label在图片下方 -------//
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, self.frame.size.width, 20)];
        descLabel.textColor = commentColor;
        descLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:descLabel];
        
        //------- 按钮在说明label下方 -------//
        UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 60, CGRectGetMaxY(descLabel.frame) + 5, 120, 25)];
        [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reloadButton.layer.borderColor = commentColor.CGColor;
        [reloadButton setTitleColor:commentColor forState:UIControlStateNormal];
        reloadButton.layer.borderWidth = 1;
        reloadButton.layer.cornerRadius = 5;
        [reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reloadButton];
        
        switch (type) {
            case PlaceholderViewTypeNoSearchData:
            {
                imageView.image = [UIImage imageNamed:@"nodata"];
                descLabel.text = @"没有搜索到数据";
                [reloadButton setTitle:@"刷新页面" forState:UIControlStateNormal];
            }
            break;
                
            case PlaceholderViewTypeNoCustomer: // 没情报
            {
                imageView.image = [UIImage imageNamed:@"nodata_customer"];
                descLabel.text = @"多添加你的专属情报吧";
                [reloadButton setTitle:@"刷新页面" forState:UIControlStateNormal];
            }
            break;
                
            case PlaceholderViewTypeNoIntelligence: // 没客户
            {
                imageView.image = [UIImage imageNamed:@"nodata_intelligence"];
                descLabel.text = @"你还没有付款客户";
                [reloadButton setTitle:@"刷新页面" forState:UIControlStateNormal];
            }
            break;

            case PlaceholderViewTypeNoNetwork: // 没网络
            {
                imageView.image = [UIImage imageNamed:@"nodata_noNetwork"];
                descLabel.text = @"网络错误";
                [reloadButton setTitle:@"刷新页面" forState:UIControlStateNormal];
            }
                break;
                
            case PlaceholderViewTypeNoFunction: // 功能建设中...
            {
                imageView.image = [UIImage imageNamed:@"nodata_noFunction"];
                descLabel.text = @"      功能完善中...";
                reloadButton.hidden = YES;
            }
                break;
                
            case PlaceholderViewTypeNoOverallSearchData: // 最近没有搜索记录...
            {
                imageView.image = [UIImage imageNamed:@"nodata_noFunction"];
                descLabel.text = @"没有搜索记录，快去搜索吧";
                reloadButton.hidden = YES;
            }
                break;
                
                
            case PlaceholderViewTypeNoAdvice: // 没有意见...
            {
                imageView.image = [UIImage imageNamed:@"nodata_noAdvice"];
                descLabel.text = @"没有历史记录";
                reloadButton.hidden = YES;
            }
                break;
                
                
            default:
                break;
        }
    }
    return self;
}


#pragma mark - 重新加载按钮点击
/** 重新加载按钮点击 */
- (void)reloadButtonClicked:(UIButton *)sender{
    // 代理方执行方法
    if ([_delegate respondsToSelector:@selector(placeholderView:reloadButtonDidClick:)]) {
        [_delegate placeholderView:self reloadButtonDidClick:sender];
    }
    
    [self removeFromSuperview];
}

@end
