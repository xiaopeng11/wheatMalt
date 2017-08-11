//
//  WheatWebView.m
//  wheatMalt
//
//  Created by 肖鹏 on 2017/8/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WheatWebView.h"

@implementation WheatWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.navigationDelegate = self;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [_activityIndicator setCenter:CGPointMake(KScreenWidth / 2.0, self.frame.size.height / 2.0)];
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityIndicator];
    }
    return self;
}

#pragma mark - 加载
- (void)loadRequestWithBody:(NSDictionary *)body
{
    //url
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenid = [userDefaults objectForKey:wheatMalt_Tokenid];
    
    NSString *webviewURLString = [NSString stringWithFormat:@"%@?gsdm=%@&token=%@&fsrqq=%@&fsrqz=%@",[@"/appreport/khzs.html" ChangeInterfaceHeader],body[@"gsdm"],tokenid,body[@"fsrqq"],body[@"fsrqz"]];
    
    NSURL *webviewURL = [NSURL URLWithString:webviewURLString];
    
    NSMutableURLRequest *assetsAccountingRequest = [[NSMutableURLRequest alloc] initWithURL:webviewURL];
    assetsAccountingRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    assetsAccountingRequest.timeoutInterval = 20;
    [assetsAccountingRequest setHTTPMethod: @"GET"];
    
    [self loadRequest:assetsAccountingRequest];
}



// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [_activityIndicator startAnimating];

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_activityIndicator stopAnimating];
    
    [self evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat webViewHeight = [result doubleValue];
        CGRect frame =self.frame;
        frame.size.height =webViewHeight;
        self.frame = frame;
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [_activityIndicator stopAnimating];

}


@end
