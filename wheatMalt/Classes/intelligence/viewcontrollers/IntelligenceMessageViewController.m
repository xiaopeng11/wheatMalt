//
//  IntelligenceMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IntelligenceMessageViewController.h"
#import "SelectPersonInChargeViewController.h"
#import "IntelligenceBugdetailsViewController.h"

#import "IntelligenceViewController.h"
#import "SpecificInformationViewController.h"
@interface IntelligenceMessageViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UIView *contentbgView;

@property(nonatomic,strong)NSMutableDictionary *IntelligenceMessage;

@property(nonatomic,assign)BOOL personInchargeChanged;
@end

@implementation IntelligenceMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.personInchargeChanged = NO;
    
    [self drawIntelligenceMessageUI];
    
    [self getIntelligenceMessageData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    if (self.navigationController.viewControllers.count == 2 && self.personInchargeChanged) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIntelligence" object:nil];
    }
}

#pragma mark - 绘制UI
- (void)drawIntelligenceMessageUI
{
    [self NavTitleWithText:[self.Intelligence valueForKey:@"gsname"]];
    
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
    
    
    NSArray *titles = @[@"客户名称:",@"联系人:",@"手机号:",@"购买方式",@"当前用户数(个):",@"到期时间:",@"负责人:"];
    NSArray *placeholders = @[@"请输入客户名称",@"请输入联系人",@"请输入手机号"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 45 * i, 130, 25)];
        title.font = SmallFont;
        title.text = titles[i];
        [_contentbgView addSubview:title];
        
        UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 44.5 + 45 * i, KScreenWidth, .5)];
        [_contentbgView addSubview:lineView];
        
        if (i < 3) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 10 + 45 * i, KScreenWidth - 150, 25)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.placeholder = placeholders[i];
            textField.font = SmallFont;
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 43000 + i;
            [_contentbgView addSubview:textField];
        } else if (i > 3 && i < titles.count - 1){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(140, 10 + 45 * i, KScreenWidth - 150, 25)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = SmallFont;
            label.tag = 43000 + i;
            label.textColor = commentColor;
            [_contentbgView addSubview:label];
        } else {
            UIButton *chargePerson = [UIButton buttonWithType:UIButtonTypeCustom];
            chargePerson.frame = CGRectMake(140, 10 + 45 * i, KScreenWidth - 165, 25);
            chargePerson.titleLabel.font = SmallFont;
            [chargePerson setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            chargePerson.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            chargePerson.backgroundColor = [UIColor whiteColor];
            chargePerson.tag = 43000 + i;
            [chargePerson addTarget:self action:@selector(changechargePerson:) forControlEvents:UIControlEventTouchUpInside];
            [_contentbgView addSubview:chargePerson];
            
            UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 25, 15 + 45 * i, 15, 15)];
            leaderView.image = [UIImage imageNamed:@"lead"];
            if (i == 3) {
                leaderView.hidden = YES;
                leaderView.tag = 43101;
            }
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self.Intelligence valueForKey:@"id"] forKey:@"id"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_IntelligenceMessage params:param Token:YES success:^(id responseObject) {
        self.IntelligenceMessage = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"VO"]];
        for (int i = 0; i < 8; i++) {
            if (i < 3) {
                UITextField *textField = (UITextField *)[_contentbgView viewWithTag:43000 + i];
                if (i == 0) {
                    textField.text = [self.IntelligenceMessage valueForKey:@"gsname"];
                } else if (i == 1) {
                    textField.text = [self.IntelligenceMessage valueForKey:@"lxr"];
                } else if (i == 2) {
                    textField.text = [self.IntelligenceMessage valueForKey:@"phone"];
                }
            } else if (i > 3 && i < 6) {
                UILabel *label = (UILabel *)[_contentbgView viewWithTag:43000 + i];
                if (i == 4) {
                    label.text = [NSString stringWithFormat:@"%@",[self.IntelligenceMessage valueForKey:@"cnumber"]];
                } else if (i == 5) {
                    label.text = [self.IntelligenceMessage valueForKey:@"enddate"];
                }
            } else if (i == 3){
                UIButton *editionBT = (UIButton *)[_contentbgView viewWithTag:43000 + i];
                if (i == 3) {
                    if ([[self.IntelligenceMessage valueForKey:@"jsfs"] intValue] == 1) {
                        [editionBT setTitle:[NSString stringWithFormat:@"按版本(%@)",[self.IntelligenceMessage valueForKey:@"ver"]] forState:UIControlStateNormal];
                        editionBT.frame = CGRectMake(140, 10 + 45 * i, KScreenWidth - 150, 25);
                        editionBT.enabled = NO;
                        [editionBT setTitleColor:commentColor forState:UIControlStateNormal];
                    } else {
                        [editionBT setTitle:@"按岗位" forState:UIControlStateNormal];
                        UIImageView *leadView = (UIImageView *)[_contentbgView viewWithTag:43101];
                        leadView.hidden = NO;
                        [editionBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            } else if (i == 6){
                UIButton *chargeBT = (UIButton *)[_contentbgView viewWithTag:43000 + i];
                NSString *chargePerson = [self.IntelligenceMessage valueForKey:@"usrname"];
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
                NSString *comments = [self.IntelligenceMessage valueForKey:@"comments"];
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
    } failure:^(NSError *error) {
    } Target:self];
}

#pragma mark - 保存客户详情
- (void)saveIntelligenceMessage
{
    UITextField *nameTF = (UITextField *)[_contentbgView viewWithTag:43000];
    UITextField *lxrTF = (UITextField *)[_contentbgView viewWithTag:43001];
    UITextField *phoneTF = (UITextField *)[_contentbgView viewWithTag:43002];
    UITextView *textView = (UITextView *)[_contentbgView viewWithTag:43007];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    if (nameTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"名称不能为空" addTarget:self];
        return;
    }
    
    if (phoneTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"手机号不能为空" addTarget:self];
        return;
    }
    
    if (![BasicControls isMobileNumber:phoneTF.text]) {
        [BasicControls showAlertWithMsg:@"请输入正确的手机号" addTarget:self];
        return;
    }
    
    
    NSArray *exitkeys = @[@"id",@"gsdm",@"lx",@"country",@"province",@"city",@"town",@"dz",@"usrid",@"zdrdm",@"zdrq",@"xgrdm",@"xgrq",@"isdelete",@"commu",@"mdgs"];
    for (NSString *key in exitkeys) {
        [para setObject:[NSString stringWithFormat:@"%@",[self.IntelligenceMessage valueForKey:key]] forKey:key];
    }
    [para setObject:nameTF.text forKey:@"gsname"];
    [para setObject:lxrTF.text forKey:@"lxr"];
    [para setObject:phoneTF.text forKey:@"phone"];
    [para setObject:textView.text forKey:@"comments"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:para forKey:@"VO"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_SaveIntelligenceMessage params:params Token:YES success:^(id responseObject) {
        [BasicControls showNDKNotifyWithMsg:@"保存成功" WithDuration:1 speed:1];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[IntelligenceViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
            if ([vc isKindOfClass:[SpecificInformationViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIntelligence" object:nil];

    } failure:^(NSError *error) {
    } Target:self];
}

#pragma mark - 按钮事件
- (void)changechargePerson:(UIButton *)button
{
    if (button.tag == 43003) {
        //岗位详情
        IntelligenceBugdetailsViewController *BugdetailsVC = [[IntelligenceBugdetailsViewController alloc] init];
        BugdetailsVC.bugdetails = self.IntelligenceMessage[@"gmgw"];
        [self.navigationController pushViewController:BugdetailsVC animated:YES];
    } else {
        //更改负责人
        SelectPersonInChargeViewController *SelectPersonInChargeVC = [[SelectPersonInChargeViewController alloc] init];
        
        SelectPersonInChargeVC.personInCharge = @{@"id":[self.IntelligenceMessage valueForKey:@"usrid"],@"name":[self.IntelligenceMessage valueForKey:@"usrname"]};
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSArray *chargepersonData = [userdefault objectForKey:wheatMalt_ChargePersonData];
        SelectPersonInChargeVC.datalist = chargepersonData;
        
        SelectPersonInChargeVC.key = @"name";
        SelectPersonInChargeVC.canConsloe = YES;

        __weak IntelligenceMessageViewController *weakSelf = self;
        SelectPersonInChargeVC.changePersnInCharge = ^(NSDictionary *personMessage){
            NSMutableDictionary *checkpersonMessage = [NSMutableDictionary dictionaryWithDictionary:personMessage];
            if ([[checkpersonMessage valueForKey:@"select"] intValue] == 0) {
                [checkpersonMessage setObject:@"0" forKey:@"id"];
                [checkpersonMessage setObject:@"" forKey:@"name"];
            }
            
            [weakSelf.IntelligenceMessage setObject:[checkpersonMessage valueForKey:@"id"] forKey:@"usrid"];
            [weakSelf.IntelligenceMessage setObject:[checkpersonMessage valueForKey:@"name"] forKey:@"usrname"];
            
            UIButton *chargeBT = (UIButton *)[weakSelf.contentbgView viewWithTag:43006];
            NSString *chargePerson = [checkpersonMessage valueForKey:@"name"];
            [chargeBT setTitle:chargePerson forState:UIControlStateNormal];
            [chargeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            NSMutableDictionary *para = [NSMutableDictionary dictionary];
            [para setObject:[checkpersonMessage valueForKey:@"id"] forKey:@"usrid"];
            [para setObject:[NSString stringWithFormat:@"%@",[weakSelf.IntelligenceMessage valueForKey:@"id"]] forKey:@"ids"];
            [HTTPRequestTool requestMothedWithPost:wheatMalt_IntelligenceChargePerson params:para Token:YES success:^(id responseObject) {
                [BasicControls showNDKNotifyWithMsg:@"修改负责人成功" WithDuration:1 speed:1];
                
                [weakSelf.IntelligenceMessage setObject:[checkpersonMessage valueForKey:@"id"] forKey:@"usrid"];
                [weakSelf.IntelligenceMessage setObject:[checkpersonMessage valueForKey:@"name"] forKey:@"usrname"];
                
                UIButton *chargeBT = (UIButton *)[weakSelf.contentbgView viewWithTag:43006];
                if ([[checkpersonMessage valueForKey:@"select"] intValue] == 0) {
                    [chargeBT setTitle:@"请选择负责人" forState:UIControlStateNormal];
                    [chargeBT setTitleColor:commentColor forState:UIControlStateNormal];
                } else {
                    [chargeBT setTitle:[checkpersonMessage valueForKey:@"name"] forState:UIControlStateNormal];
                    [chargeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
                self.personInchargeChanged = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIntelligence" object:nil];

            } failure:^(NSError *error) {
                
            } Target:nil];
            
        };
        [self.navigationController pushViewController:SelectPersonInChargeVC animated:YES];
    }
    
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
