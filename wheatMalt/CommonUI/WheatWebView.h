//
//  WheatWebView.h
//  wheatMalt
//
//  Created by 肖鹏 on 2017/8/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WheatWebView : WKWebView<WKNavigationDelegate>
{
    UIActivityIndicatorView *_activityIndicator;  //动画
}
//加载数据
- (void)loadRequestWithBody:(NSDictionary *)body;
@end
