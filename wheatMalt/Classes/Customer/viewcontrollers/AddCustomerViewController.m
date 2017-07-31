//
//  AddCustomerViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddCustomerViewController.h"

@interface AddCustomerViewController ()<UITextViewDelegate>
{
    UIView *_newCustomerbgView;
    
    BOOL _openWraning;
}
@end

@implementation AddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _openWraning = NO;
    
    [self drawAddCustomerUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawAddCustomerUI
{
    NSMutableArray *titles = [NSMutableArray arrayWithArray:@[@"开启提醒:",@"名称:",@"门店数",@"联系人:",@"手机号:",@"地址:"]];
    NSMutableArray *values = [NSMutableArray array];
    if (self.customer == nil) {
        [self NavTitleWithText:@"新增情报"];
    } else {
        [self NavTitleWithText:@"详情编辑"];
        [titles removeObjectAtIndex:0];
        [values addObject:[self.customer valueForKey:@"gsname"]];
        [values addObject:[self.customer valueForKey:@"mdgs"]];
        [values addObject:[self.customer valueForKey:@"lxr"]];
        [values addObject:[self.customer valueForKey:@"phone"]];
        [values addObject:[self.customer valueForKey:@"dz"]];
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(saveCustomer)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BaseBgColor;
    [self.view addSubview:scrollView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    headerView.backgroundColor = BaseBgColor;
    [scrollView addSubview:headerView];
    
    _newCustomerbgView = [[UIView alloc] init];
    _newCustomerbgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_newCustomerbgView];
    
    
    NSArray *placeholders = @[@"请输入名称",@"请输入门店数",@"请输入联系人名称",@"请输入手机号",@"请输入地址"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * i, 150, 25)];
        title.font = SmallFont;
        title.text = titles[i];
        [_newCustomerbgView addSubview:title];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
        [_newCustomerbgView addSubview:lineView];
        
        if (i == 0 && titles.count == 6) {
            UIButton *warningBT = [UIButton buttonWithType:UIButtonTypeCustom];
            warningBT.frame = CGRectMake(KScreenWidth - 70, 6.25, 60, 37.5);
            [warningBT setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
            [warningBT addTarget:self action:@selector(openWraningState:) forControlEvents:UIControlEventTouchUpInside];
            [_newCustomerbgView addSubview:warningBT];
        } else {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 10 + 45 * i, KScreenWidth - 170, 25)];
            textField.textAlignment = NSTextAlignmentRight;
            if (titles.count == 6) {
                textField.placeholder = placeholders[i - 1];
                if (self.customer != nil) {
                    textField.text = values[i - 1];
                }
            } else {
                textField.placeholder = placeholders[i];
                textField.text = values[i];
            }
            textField.font = SmallFont;
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 20000 + i;
            [_newCustomerbgView addSubview:textField];
        }
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * titles.count, 50, 25)];
    title.font = SmallFont;
    title.text = @"备注:";
    [_newCustomerbgView addSubview:title];
    
    UIButton *textPlacerHolder = [UIButton buttonWithType:UIButtonTypeCustom];
    textPlacerHolder.frame = CGRectMake(60, 10 + 45 * titles.count, KScreenWidth - 70, 25);
    textPlacerHolder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    textPlacerHolder.backgroundColor = [UIColor whiteColor];
    textPlacerHolder.titleLabel.font = SmallFont;
    [textPlacerHolder setTitleColor:commentColor forState:UIControlStateNormal];
    [textPlacerHolder setTitle:@"请输入备注内容" forState:UIControlStateNormal];
    [textPlacerHolder setUserInteractionEnabled:NO];
    textPlacerHolder.tag = 20010;
    [_newCustomerbgView addSubview:textPlacerHolder];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(60, 5 + 45 * titles.count, KScreenWidth - 70, 80)];
    textView.backgroundColor = [UIColor clearColor];
    textView.tag = 20000 + titles.count;
    textView.delegate = self;
    textView.font = SmallFont;
    NSString *comments = [self.customer valueForKey:@"comments"];
    textView.text = comments;
    if (comments.length != 0) {
        textPlacerHolder.hidden = YES;
        if ([textView sizeThatFits:CGSizeMake(KScreenWidth - 70, 0)].height < 40) {
            textView.textAlignment = NSTextAlignmentRight;
        } else {
            textView.textAlignment = NSTextAlignmentLeft;
        }
    } else {
        textPlacerHolder.hidden = NO;
    }
    [_newCustomerbgView addSubview:textView];
    
    _newCustomerbgView.frame = CGRectMake(0, 10, KScreenWidth, 45 * titles.count + 80 + 10);
    scrollView.contentSize = _newCustomerbgView.height < KScreenHeight ? CGSizeMake(KScreenWidth, KScreenHeight) : CGSizeMake(KScreenWidth, 10 + 45 * titles.count + 80 + 10);
}

#pragma mark - 保存情报
- (void)saveCustomer
{
    [self.view endEditing:YES];

    UITextField *nameTF = (UITextField *)[_newCustomerbgView viewWithTag:20001];
    UITextField *storeNumTF = (UITextField *)[_newCustomerbgView viewWithTag:20002];
    UITextField *lxrTF = (UITextField *)[_newCustomerbgView viewWithTag:20003];
    UITextField *phoneTF = (UITextField *)[_newCustomerbgView viewWithTag:20004];
    UITextField *addressTF = (UITextField *)[_newCustomerbgView viewWithTag:20005];
    UITextView *commentTF = (UITextView *)[_newCustomerbgView viewWithTag:20006];

    NSMutableDictionary *param;
    if (self.customer == nil) {
        param = [NSMutableDictionary dictionary];
    } else {
        param = [NSMutableDictionary dictionaryWithDictionary:self.customer];
    }
    [param setObject:nameTF.text forKey:@"gsname"];
    [param setObject:@([storeNumTF.text intValue]) forKey:@"mdgs"];
    [param setObject:lxrTF.text forKey:@"lxr"];
    [param setObject:phoneTF.text forKey:@"phone"];
    [param setObject:addressTF.text forKey:@"dz"];
    [param setObject:commentTF.text forKey:@"comments"];
    
    if (self.customer == nil) {
        _openWraning == YES ? [param setObject:@(1) forKey:@"txflag"] : [param setObject:@(0) forKey:@"txflag"];
        [param setObject:@"" forKey:@"txdate"];
    }
    
    if (nameTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"名称不能为空" addTarget:self];
        return;
    }
    [HTTPRequestTool requestMothedWithPost:wheatMalt_AddCustomer params:param Token:YES success:^(id responseObject) {
        if (self.addNewCustomer) {
            self.addNewCustomer(param);
        }
        [self.navigationController popViewControllerAnimated:YES];
        [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
    } failure:^(NSError *error) {
        
    } Target:self];
}

#pragma mark - 提醒按钮
- (void)openWraningState:(UIButton *)button
{
    _openWraning = !_openWraning;
    if (_openWraning) {
        [button setImage:[UIImage imageNamed:@"button_open"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UIButton *textBT = (UIButton *)[_newCustomerbgView viewWithTag:20010];
    if (textView.text.length != 0) {
        textBT.hidden = YES;
    } else {
        textBT.hidden = NO;
    }
}
@end
