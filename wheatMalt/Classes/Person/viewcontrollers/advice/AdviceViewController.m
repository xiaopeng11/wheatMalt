//
//  AdviceViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AdviceViewController.h"
#import "AdviceHistoryViewController.h"
@interface AdviceViewController ()<UITextViewDelegate>

{
    BOOL _needReport;
    
    UITextView *_textView;
    UIButton *_palcerHolderBT;
}
@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _needReport = NO;
    
    [self NavTitleWithText:@"意见反馈"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"反馈历史" target:self action:@selector(adviceHistory)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    _palcerHolderBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _palcerHolderBT.titleLabel.font = SmallFont;
    [_palcerHolderBT setTitleColor:commentColor forState:UIControlStateNormal];
    _palcerHolderBT.frame = CGRectMake(13, 15, KScreenWidth, 25);
    _palcerHolderBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_palcerHolderBT setTitle:@"麦尔芽的成长，离不开你的意见和建议" forState:UIControlStateNormal];
    [bgView addSubview:_palcerHolderBT];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 180)];
    _textView.font = SmallFont;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [bgView addSubview:_textView];
    
    UIView *reportBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 210, KScreenWidth, 50)];
    reportBgview.backgroundColor = [UIColor whiteColor];
    reportBgview.userInteractionEnabled = YES;
    [self.view addSubview:reportBgview];
    
    UILabel *reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 160, 13, 100, 24)];
    reportLabel.font = SmallFont;
    reportLabel.textAlignment = NSTextAlignmentRight;
    reportLabel.text = @"违规举报";
    [reportBgview addSubview:reportLabel];
    
    UIButton *reportBT = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBT.frame = CGRectMake(KScreenWidth - 50, 10, 40, 30);
    [reportBT setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [reportBT addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
    [reportBgview addSubview:reportBT];
    
    UIButton *suggestAdvice = [UIButton buttonWithType:UIButtonTypeCustom];
    suggestAdvice.frame = CGRectMake(30, 280, KScreenWidth - 60, 40);
    suggestAdvice.layer.cornerRadius = 20;
    suggestAdvice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [suggestAdvice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [suggestAdvice setTitle:@"提交" forState:UIControlStateNormal];
    [suggestAdvice setBackgroundColor:ButtonHColor];
    [suggestAdvice addTarget:self action:@selector(suggestAdvice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suggestAdvice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        [_palcerHolderBT setTitle:@"" forState:UIControlStateNormal];
    } else {
        [_palcerHolderBT setTitle:@"麦尔芽的成长，离不开你的意见和建议" forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮事件
/**
 是否违规
 */
- (void)report:(UIButton *)buttton
{
    if (_needReport) {
        [buttton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    } else {
        [buttton setImage:[UIImage imageNamed:@"button_open"] forState:UIControlStateNormal];
    }
    
    _needReport = !_needReport;
}

/**
 提交建议
 */
- (void)suggestAdvice
{
    NSLog(@"%@\n%d",_textView.text,_needReport);
}

/**
 反馈历史
 */
- (void)adviceHistory
{
    AdviceHistoryViewController *AdviceHistoryVC = [[AdviceHistoryViewController alloc] init];
    [self.navigationController pushViewController:AdviceHistoryVC animated:YES];
}
@end
