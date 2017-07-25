//
//  HomeTimeRangeChooseViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomeTimeRangeChooseViewController.h"

#import "SpecificInformationViewController.h"
#import "IntelligenceChoosedViewController.h"

#import "CustomPicker.h"
@interface HomeTimeRangeChooseViewController ()<UITextFieldDelegate>
{
    UITextField *_beginTF;
    UITextField *_endTF;
    UIView *_beginLine;
    UIView *_endLine;
    NSDateFormatter *_form;
}
@property(nonatomic,assign)BOOL begin;

@end

@implementation HomeTimeRangeChooseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    _begin = YES;
    
    _form = [[NSDateFormatter alloc] init];
    _form.dateFormat = @"yyyy-MM-dd";
    
    [self drawDateChoose];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeHadChanged:) name:@"timeChanged" object:nil];
}

#pragma mark - 绘制UI
- (void)drawDateChoose
{
    [self NavTitleWithText:@"时间段选择"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"完成" target:self action:@selector(finishChoose)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _beginTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, (KScreenWidth - 100) / 2.0, 40)];
    _beginTF.textColor = [UIColor colorWithHexString:@"#50acef"];
    _beginTF.placeholder = @"开始时间";
    _beginTF.delegate = self;
    _beginTF.textAlignment = NSTextAlignmentCenter;
    
    _beginLine = [[UIView alloc] initWithFrame:CGRectMake(20, 40, (KScreenWidth - 100) / 2.0, .5)];
    _beginLine.backgroundColor = [UIColor colorWithHexString:@"#50acef"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + ((KScreenWidth - 100) / 2.0), 0, 60, 40)];
    label.text = @"至";
    label.textAlignment = NSTextAlignmentCenter;
    
    
    _endTF = [[UITextField alloc] initWithFrame:CGRectMake(((KScreenWidth - 100) / 2.0) + 80, 0, (KScreenWidth - 100) / 2.0, 40)];
    _endTF.textColor = [UIColor colorWithHexString:@"#50acef"];
    _endTF.placeholder = @"结束时间";
    _endTF.delegate = self;
    _endTF.textAlignment = NSTextAlignmentCenter;
    
    _endLine = [[UIView alloc] initWithFrame:CGRectMake(((KScreenWidth - 100) / 2.0) + 80, 40, (KScreenWidth - 100) / 2.0, .5)];
    _endLine.backgroundColor = [UIColor lightGrayColor];
    
    NSString *dateString = [_form stringFromDate:[NSDate date]];
    _beginTF.text = [NSString stringWithFormat:@"%@-%@-%@",[dateString substringToIndex:4],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)]];
    
    
    [bgView addSubview:_beginTF];
    [bgView addSubview:_endTF];
    [bgView addSubview:_beginLine];
    [bgView addSubview:_endLine];
    [bgView addSubview:label];
    
    UIButton *deleteTime = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteTime.frame = CGRectMake(KScreenWidth - 50, 45, 25, 25);
    [deleteTime setImage:[UIImage imageNamed:@"rebush"] forState:UIControlStateNormal];
    [deleteTime addTarget:self action:@selector(deleteTime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:deleteTime];
    
    CustomPicker *datepicker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, 75, KScreenWidth, 200)];
    [bgView addSubview:datepicker];
    
}

#pragma mark - 通知
- (void)timeHadChanged:(NSNotification *)noti
{
    if (_begin) {
        _beginTF.text = noti.object;
    } else {
        _endTF.text = noti.object;
    }
}

#pragma mark - 按钮事件
/**
 删除时间
 */
- (void)deleteTime
{
    _beginTF.text = @"";
    _endTF.text = @"";
    _endLine.backgroundColor = [UIColor lightGrayColor];
    _beginLine.backgroundColor = [UIColor lightGrayColor];
}

/**
 确定选择
 */
- (void)finishChoose
{
    if ([self.superView isEqualToString:@"Home"]) {
        SpecificInformationViewController *SpecificInformationVC = [[SpecificInformationViewController alloc] init];
        SpecificInformationVC.paras = @[_beginTF.text,_endTF.text];
        [self.navigationController pushViewController:SpecificInformationVC animated:YES];
    } else if ([self.superView isEqualToString:@"ChooseIntelligence"]) {
        IntelligenceChoosedViewController *IntelligenceChoosedVC = [[IntelligenceChoosedViewController alloc] init];
        IntelligenceChoosedVC.paras = @[_beginTF.text,_endTF.text];
        [self.navigationController pushViewController:IntelligenceChoosedVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _begin = [textField isEqual:_beginTF] ? YES : NO;
    if ([textField isEqual:_beginTF]) {
        if (_endTF.text.length != 0) {
            _endTF.textColor = [UIColor blackColor];
            _beginTF.text = _endTF.text;
        }
        _beginTF.textColor = [UIColor colorWithHexString:@"#50acef"];
        _endLine.backgroundColor = [UIColor lightGrayColor];
        _beginLine.backgroundColor = [UIColor colorWithHexString:@"#50acef"];
    }
    if ([textField isEqual:_endTF]) {
        if (_beginTF.text.length != 0) {
            _beginTF.textColor = [UIColor blackColor];
            _endTF.text = _beginTF.text;
        }
        _endTF.textColor = [UIColor colorWithHexString:@"#50acef"];
        _endLine.backgroundColor = [UIColor colorWithHexString:@"#50acef"];
        _beginLine.backgroundColor = [UIColor lightGrayColor];
    }
    return NO;
}




@end
