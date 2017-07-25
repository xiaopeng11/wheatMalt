//
//  IntelligenceMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IntelligenceMessageViewController.h"
#import "SelectPersonInChargeViewController.h"

@interface IntelligenceMessageViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UIView *contentbgView;

@property(nonatomic,strong)NSMutableDictionary *IntelligenceMessage;
@end

@implementation IntelligenceMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawIntelligenceMessageUI];
    
    [self getIntelligenceMessageData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawIntelligenceMessageUI
{
    [self NavTitleWithText:[self.Intelligence valueForKey:@"name"]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(saveIntelligenceMessage)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BaseBgColor;
    [self.view addSubview:scrollView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    headerView.backgroundColor = BaseBgColor;
    [scrollView addSubview:headerView];
    
    _contentbgView = [[UIView alloc] init];
    _contentbgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_contentbgView];
    
    
    NSArray *titles = @[@"客户名称:",@"联系人:",@"手机号:",@"当前版本:",@"当前用户数(个):",@"到期时间:",@"负责人:"];
    NSArray *placeholders = @[@"请输入客户名称",@"请输入联系人",@"请输入手机号"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * i, 150, 25)];
        title.font = SmallFont;
        title.text = titles[i];
        [_contentbgView addSubview:title];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
        [_contentbgView addSubview:lineView];
        
        if (i < 3) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 10 + 45 * i, KScreenWidth - 170, 25)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.placeholder = placeholders[i];
            textField.font = SmallFont;
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 43000 + i;
            [_contentbgView addSubview:textField];
        } else if (i >= 3 && i < titles.count - 1){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(160, 10 + 45 * i, KScreenWidth - 170, 25)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = SmallFont;
            label.tag = 43000 + i;
            [_contentbgView addSubview:label];
        } else {
            UIButton *chargePerson = [UIButton buttonWithType:UIButtonTypeCustom];
            chargePerson.frame = CGRectMake(160, 10 + 45 * i, KScreenWidth - 185, 25);
            chargePerson.titleLabel.font = SmallFont;
            chargePerson.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            chargePerson.backgroundColor = [UIColor whiteColor];
            chargePerson.tag = 43000 + i;
            [chargePerson addTarget:self action:@selector(changechargePerson) forControlEvents:UIControlEventTouchUpInside];
            [_contentbgView addSubview:chargePerson];
            
            UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 25, 15 + 45 * i, 15, 15)];
            leaderView.image = [UIImage imageNamed:@"lead"];
            [_contentbgView addSubview:leaderView];
        }
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * 7, 50, 25)];
    title.font = SmallFont;
    title.text = @"备注:";
    [_contentbgView addSubview:title];
    
    UIButton *textPlacerHolder = [UIButton buttonWithType:UIButtonTypeCustom];
    textPlacerHolder.frame = CGRectMake(60, 10 + 45 * 7, KScreenWidth - 70, 25);
    textPlacerHolder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    textPlacerHolder.backgroundColor = [UIColor whiteColor];
    textPlacerHolder.titleLabel.font = SmallFont;
    [textPlacerHolder setTitleColor:commentColor forState:UIControlStateNormal];
    [textPlacerHolder setTitle:@"请输入备注内容" forState:UIControlStateNormal];
    [textPlacerHolder setUserInteractionEnabled:NO];
    textPlacerHolder.hidden = YES;
    textPlacerHolder.tag = 43010 + titles.count;
    [_contentbgView addSubview:textPlacerHolder];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(60, 5 + 45 * 7, KScreenWidth - 70, 80)];
    textView.backgroundColor = [UIColor clearColor];
    textView.tag = 43000 + titles.count;
    textView.delegate = self;
    textView.font = SmallFont;
    [_contentbgView addSubview:textView];
    
    _contentbgView.frame = CGRectMake(0, 10, KScreenWidth, 45 * 7 + 80 + 10);
    scrollView.contentSize = _contentbgView.height < KScreenHeight ? CGSizeMake(KScreenWidth, KScreenHeight) : CGSizeMake(KScreenWidth, 10 + 45 * 7 + 80 + 10);
    
    
}

#pragma mark - 获取数据
- (void)getIntelligenceMessageData
{
    _IntelligenceMessage = [NSMutableDictionary dictionaryWithDictionary:IntelligenceMessageData];

    for (int i = 0; i < 8; i++) {
        if (i < 3) {
            UITextField *textField = (UITextField *)[_contentbgView viewWithTag:43000 + i];
            if (i == 0) {
                textField.text = [_IntelligenceMessage valueForKey:@"name"];
            } else if (i == 1) {
                textField.text = [_IntelligenceMessage valueForKey:@"lxr"];
            } else if (i == 2) {
                textField.text = [_IntelligenceMessage valueForKey:@"phone"];
            }
        } else if (i >=3 && i < 6) {
            UILabel *label = (UILabel *)[_contentbgView viewWithTag:43000 + i];
            if (i == 3) {
                label.text = [_IntelligenceMessage valueForKey:@"Edition"];
            } else if (i == 4) {
                label.text = [NSString stringWithFormat:@"%@",[_IntelligenceMessage valueForKey:@"nums"]];
            } else if (i == 5) {
                label.text = [_IntelligenceMessage valueForKey:@"date"];
            }
        } else if (i == 6){
            UIButton *chargeBT = (UIButton *)[_contentbgView viewWithTag:43000 + i];
            NSString *chargePerson = [_IntelligenceMessage valueForKey:@"chargePerson"];
            if (chargePerson.length > 0) {
                [chargeBT setTitle:chargePerson forState:UIControlStateNormal];
                [chargeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [chargeBT setTitle:@"请选择负责人" forState:UIControlStateNormal];
                [chargeBT setTitleColor:commentColor forState:UIControlStateNormal];
            }
        } else {
            UITextView *textView = (UITextView *)[_contentbgView viewWithTag:43000 + i];
            UIButton *textBT = (UIButton *)[_contentbgView viewWithTag:43010 + i];
            NSString *comments = [_IntelligenceMessage valueForKey:@"comments"];
            if (comments.length == 0) {
                textBT.hidden = NO;
            } else {
                textBT.hidden = YES;
                textView.text = comments;
                if ([textView sizeThatFits:CGSizeMake(KScreenWidth - 70, 0)].height < 40) {
                    textView.textAlignment = NSTextAlignmentRight;
                } else {
                    textView.textAlignment = NSTextAlignmentLeft;
                }
            }
        }
    }
    
}

#pragma mark - 保存客户详情
- (void)saveIntelligenceMessage
{
    
}

#pragma mark - 更改负责人
- (void)changechargePerson
{
    SelectPersonInChargeViewController *SelectPersonInChargeVC = [[SelectPersonInChargeViewController alloc] init];
    SelectPersonInChargeVC.personInCharge = @{@"id":[self.IntelligenceMessage valueForKey:@"chargeid"],@"name":[self.IntelligenceMessage valueForKey:@"chargePerson"]};
    SelectPersonInChargeVC.datalist = personData;
    SelectPersonInChargeVC.key = @"name";
    __weak IntelligenceMessageViewController *weakSelf = self;
    SelectPersonInChargeVC.changePersnInCharge = ^(NSDictionary *personMessage){
        [weakSelf.IntelligenceMessage setObject:[personMessage valueForKey:@"id"] forKey:@"chargeid"];
        [weakSelf.IntelligenceMessage setObject:[personMessage valueForKey:@"name"] forKey:@"chargePerson"];
        
        UIButton *chargeBT = (UIButton *)[weakSelf.contentbgView viewWithTag:43006];
        NSString *chargePerson = [weakSelf.IntelligenceMessage valueForKey:@"chargePerson"];
        [chargeBT setTitle:chargePerson forState:UIControlStateNormal];
        [chargeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:SelectPersonInChargeVC animated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UIButton *textBT = (UIButton *)[_contentbgView viewWithTag:43017];
    if (textView.text.length != 0) {
        textBT.hidden = YES;
    } else {
        textBT.hidden = NO;
    }
}

@end
