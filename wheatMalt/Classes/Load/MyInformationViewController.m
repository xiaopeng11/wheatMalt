//
//  MyInformationViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyInformationViewController.h"

#import "AreaChooseViewController.h"
#import "WaitCheckViewController.h"
@interface MyInformationViewController ()<UITextViewDelegate,UITextFieldDelegate>

{
    UIView *headerBgView;
    UITextView *_PersonalevaluationTV;

    NSString *_area;
    UITextField *_nameTF;
    UIButton *_areaButton;
    
    UIButton *textPlacerHolder;
}
@end

@implementation MyInformationViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeArea" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeArea:) name:@"changeArea" object:nil];
    
    _area = [NSString string];
    
    
    [self NavTitleWithText:@"完善信息"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"提交" target:self action:@selector(unloadData)];
    
    
    headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    [headerBgView setUserInteractionEnabled:YES];
    [self.view addSubview:headerBgView];
    
    NSArray *titles = @[@"姓名:",@"期望负责地区:"];
    NSArray *placers = @[@"请输入姓名",@"请选择地区"];
    for (int i = 0; i < 2; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + (45 * i), 100, 25)];
        titleLabel.text = titles[i];
        titleLabel.font = SmallFont;
        [headerBgView addSubview:titleLabel];
    }
    
     _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, KScreenWidth - 120, 45)];
     _nameTF.backgroundColor = [UIColor whiteColor];
     _nameTF.font = SmallFont;
     _nameTF.placeholder = placers[0];
     _nameTF.textAlignment = NSTextAlignmentRight;
     [headerBgView addSubview:_nameTF];
    
    _areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _areaButton.frame = CGRectMake(110, 45, KScreenWidth - 120, 45);
    _areaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _areaButton.backgroundColor = [UIColor whiteColor];
    _areaButton.titleLabel.font = SmallFont;
    [_areaButton setTitleColor:commentColor forState:UIControlStateNormal];
    [_areaButton setTitle:@"请选择地区" forState:UIControlStateNormal];
    [_areaButton addTarget:self action:@selector(setArea) forControlEvents:UIControlEventTouchUpInside];
    [headerBgView addSubview:_areaButton];

    
    UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5, KScreenWidth, .5)];
    [headerBgView addSubview:lineView];
    
    UIView *tVbgView= [[UIView alloc] initWithFrame:CGRectMake(0, 90 + 10, KScreenWidth, KScreenHeight - 64 - 20 - 90)];
    tVbgView.backgroundColor = [UIColor whiteColor];
    [tVbgView setUserInteractionEnabled:YES];
    [self.view addSubview:tVbgView];
    
    _PersonalevaluationTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 200)];
    _PersonalevaluationTV.font = SmallFont;
    _PersonalevaluationTV.delegate = self;
    [tVbgView addSubview:_PersonalevaluationTV];
    
    textPlacerHolder = [UIButton buttonWithType:UIButtonTypeCustom];
    textPlacerHolder.frame = CGRectMake(20, 10, KScreenWidth - 40, 30);
    textPlacerHolder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textPlacerHolder.backgroundColor = [UIColor whiteColor];
    textPlacerHolder.titleLabel.font = SmallFont;
    [textPlacerHolder setTitleColor:commentColor forState:UIControlStateNormal];
    [textPlacerHolder setTitle:@"自我评价(相关从业经验,自我评价,300字以内)" forState:UIControlStateNormal];
    [textPlacerHolder setUserInteractionEnabled:NO];
    [tVbgView addSubview:textPlacerHolder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮信息
- (void)unloadData
{
    NSLog(@"%@%@\n%@",_nameTF.text,_area,_PersonalevaluationTV.text);
    WaitCheckViewController *waitVC = [[WaitCheckViewController alloc] init];
    [self.navigationController pushViewController:waitVC animated:YES];
}

- (void)setArea
{
    AreaChooseViewController *AreaChooseVC = [[AreaChooseViewController alloc] init];
    [self.navigationController pushViewController:AreaChooseVC animated:YES];
}

#pragma mark - 通知事件
- (void)changeArea:(NSNotification *)noti
{
    [_areaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_areaButton setTitle:noti.object forState:UIControlStateNormal];
    _area = noti.object;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 300 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum != 0) {
        textPlacerHolder.hidden = YES;
    } else {
        textPlacerHolder.hidden = NO;
    }
    if (existTextNum > 300)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:300];
        
        [textView setText:s];
    }
}
@end
