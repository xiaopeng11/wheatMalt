//
//  AdviceMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AdviceMessageViewController.h"

@interface AdviceMessageViewController ()

@end

@implementation AdviceMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"意见详情"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 180)];
    textView.font = SmallFont;
    textView.backgroundColor = [UIColor clearColor];
    textView.text = [self.AdviceMessage valueForKey:@"advice"];
    textView.userInteractionEnabled = NO;
    [bgView addSubview:textView];
    
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
    [[self.AdviceMessage valueForKey:@"lx"] isEqualToString:@"0"] ? [reportBT setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal] :  [reportBT setImage:[UIImage imageNamed:@"button_open"] forState:UIControlStateNormal];
    reportBT.userInteractionEnabled = NO;
    [reportBgview addSubview:reportBT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
