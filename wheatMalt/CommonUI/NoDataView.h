//
//  NoDataView.h
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 占位图的类型 */
typedef NS_ENUM(NSInteger, PlaceholderViewType) {
    /** 未搜索到数据 */
    PlaceholderViewTypeNoSearchData = 1,
    /** 没添加情报 */
    PlaceholderViewTypeNoCustomer,
    /** 没有客户 */
    PlaceholderViewTypeNoIntelligence,
    /** 没有网络 */
    PlaceholderViewTypeNoNetwork,
};
#pragma mark - @protocol

@class NoDataView;

@protocol PlaceholderViewDelegate <NSObject>

/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(NoDataView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender;

@end

@interface NoDataView : UIView

@property(nonatomic,strong)NSString *showPlacerHolder;
/** 占位图的代理方（只读） */
@property (nonatomic, weak, readonly) id <PlaceholderViewDelegate> delegate;


/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame
                        type:(PlaceholderViewType )type
                     delegate:(id)delegate;
@end
