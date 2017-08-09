//
//  UserMessageViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserMessageViewController.h"
#import "UserHeaderViewViewController.h"
#import "showVViewController.h"

#import "BaseNavigationController.h"
#import "LoadingViewController.h"
@interface UserMessageViewController ()
{
    NSMutableDictionary *_personMessageData;
    UIView *_bgView;
}
@end

@implementation UserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //0:公司,1:客户经理,2:商务,3:研发
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    
    
    _personMessageData = [NSMutableDictionary dictionary];
    [_personMessageData setObject:[userMessage valueForKey:@"name"] forKey:@"name"];
    [_personMessageData setObject:[userMessage valueForKey:@"phone"] forKey:@"phone"];
    [_personMessageData setObject:[userMessage valueForKey:@"zw"] forKey:@"zw"];
    [_personMessageData setObject:[userMessage valueForKey:@"level"] forKey:@"level"];
    [_personMessageData setObject:[userMessage valueForKey:@"dz"] forKey:@"dz"];
    NSString *userpic = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_100,w_100",[userMessage valueForKey:@"userpic"]];
    
    [_personMessageData setObject:userpic forKey:@"userpic"];
    [_personMessageData setObject:[userMessage valueForKey:@"fd"] forKey:@"fd"];
    
    
    [self drawUserMessageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawUserMessageUI
{
    [self NavTitleWithText:@"个人信息"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"保存" target:self action:@selector(savePersonMessage)];
    
    UIScrollView *scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    scrollView.userInteractionEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BaseBgColor;
    [self.view addSubview:scrollView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 330)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [scrollView addSubview:_bgView];
    
    NSArray *array = @[@"头像",@"昵称",@"手机号",@"我的V级",@"我的返利比",@"地址"];
    NSArray *placers = @[@"",@"请输入昵称",@"请输入手机号",@"",@"",@"请输入地址"];
    NSArray *Vs = @[@[@"V1_1",@"V1_2",@"V1_3"],@[@"V2_1",@"V2_2",@"V2_3"],@[@"V3_1",@"V3_2",@"V3_3"],@[@"V0"]];
    
    for (int i = 0; i < array.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        UIView *lineView;
        UITextField *textField = [[UITextField alloc] init];
        textField.tag = 51100 + i;
        if (i == 0) {
            titleLabel.frame = CGRectMake(10, 20, 100, 30);
            titleLabel.font = LargeFont;
            lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 80, KScreenWidth, .5)];
            
            UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 85, 15, 50, 50)];
            headerView.clipsToBounds = YES;
            headerView.layer.cornerRadius = 10;
            [headerView sd_setImageWithURL:[_personMessageData valueForKey:@"userpic"] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];
            [_bgView addSubview:headerView];
            
            UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 32.5, 20, 20)];
            leaderView.image = [UIImage imageNamed:@"lead"];
            [_bgView addSubview:leaderView];
            
            UIButton *chooseHead = [UIButton buttonWithType:UIButtonTypeCustom];
            chooseHead.frame = CGRectMake(0, 0, KScreenWidth, 80);
            [chooseHead addTarget:self action:@selector(changeHeaderPicAction) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:chooseHead];
        } else {
            titleLabel.frame = CGRectMake(10, 80 + 10 + (50 * (i - 1)), 100, 30);
            titleLabel.font = SmallFont;
            if (i < array.count - 1) {
                lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 80 + 50 * i, KScreenWidth, .5)];
            }
            
            if (i == 1 || i == 2 || i == 5) {
                textField.frame = CGRectMake(110, 80 + 10 + (50 * (i - 1)), KScreenWidth - 120, 30);
                textField.borderStyle = UITextBorderStyleNone;
                textField.font = SmallFont;
                textField.placeholder = placers[i];
                textField.textAlignment = NSTextAlignmentRight;
                if (i == 1) {
                    textField.text = [_personMessageData valueForKey:@"name"];
                } else if (i == 2) {
                    textField.text = [_personMessageData valueForKey:@"phone"];
                } else if (i == 5) {
                    textField.text = [_personMessageData valueForKey:@"dz"];
                }
                textField.tag = 52310 + i;
                [_bgView addSubview:textField];
            }
            
            if (i == 3) {
                UIImageView *VView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 60, 10 + 80 + 50 * 2, 30, 30)];
                NSInteger lx = [[_personMessageData valueForKey:@"zw"] integerValue];
                NSInteger level = [[_personMessageData valueForKey:@"level"] integerValue];
                
                VView.image = [UIImage imageNamed:Vs[lx - 1][level - 1]];
                [_bgView addSubview:VView];
                
                UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 180 + 17.5, 20, 20)];
                leaderView.image = [UIImage imageNamed:@"lead"];
                [_bgView addSubview:leaderView];
                
                UIButton *chooseHead = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseHead.frame = CGRectMake(0, 180, KScreenWidth, 50);
                [chooseHead addTarget:self action:@selector(showV) forControlEvents:UIControlEventTouchUpInside];
                [_bgView addSubview:chooseHead];
            }
            if (i == 4) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 80 + 10 + (50 * (i - 1)), KScreenWidth - 135, 30)];
                label.text = [NSString stringWithFormat:@"%@",[_personMessageData valueForKey:@"fd"]];
                label.font = SmallFont;
                label.textAlignment = NSTextAlignmentRight;
                [_bgView addSubview:label];
                
                UIImageView *leaderView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 230 + 17.5, 20, 20)];
                leaderView.image = [UIImage imageNamed:@"lead"];
                [_bgView addSubview:leaderView];
                
                UIButton *chooseHead = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseHead.frame = CGRectMake(0, 80 + (50 * (i - 1)), KScreenWidth, 50);
                [chooseHead addTarget:self action:@selector(showFLBHistory) forControlEvents:UIControlEventTouchUpInside];
                [_bgView addSubview:chooseHead];
            }
        }
        
        titleLabel.text = array[i];
        [_bgView addSubview:titleLabel];
        [_bgView addSubview:lineView];
    }
    
    scrollView.contentSize = KScreenHeight - 64 > 350 ? CGSizeMake(KScreenWidth, KScreenHeight - 64 + 10) : CGSizeMake(KScreenWidth, 350);
}

#pragma mark - 按钮事件
/**
 更换头像
 */
- (void)changeHeaderPicAction
{
    UserHeaderViewViewController *UserHeaderViewVC = [[UserHeaderViewViewController alloc] init];
    [self.navigationController pushViewController:UserHeaderViewVC animated:YES];
}

/**
 v等级
 */
- (void)showV
{
    showVViewController *showVVC = [[showVViewController alloc] init];
    [self.navigationController pushViewController:showVVC animated:YES];
}

/**
 返利比
 */
- (void)showFLBHistory
{
    NSLog(@"返利比");
}

#pragma mark - 保存数据
- (void)savePersonMessage
{
    
    [self.view endEditing:YES];
    
    UITextField *nameTF = (UITextField *)[_bgView viewWithTag:52311];
    UITextField *phoneTF = (UITextField *)[_bgView viewWithTag:52312];
    UITextField *dzTF = (UITextField *)[_bgView viewWithTag:52315];
    
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:userMessage];
    [params setObject:nameTF.text forKey:@"name"];
    [params setObject:phoneTF.text forKey:@"phone"];
    [params setObject:dzTF.text forKey:@"dz"];
    
    if (![phoneTF.text isEqualToString:userMessage[@"phone"]]) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号被修改后将重新登陆！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HTTPRequestTool requestMothedWithPost:wheatMalt_changePersonMessage params:params Token:YES success:^(id responseObject) {
                    [userdefaluts setObject:@NO forKey:wheatMalt_isLoading];
                    [userdefaluts removeObjectForKey:wheatMalt_Tokenid];
                    [userdefaluts synchronize];
                    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[LoadingViewController alloc] init]];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    window.rootViewController = nav;
            } failure:^(NSError *error) {
            } Target:self];
        }];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertcontroller addAction:cancelaction];
        [alertcontroller addAction:okaction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    } else {
        [HTTPRequestTool requestMothedWithPost:wheatMalt_changePersonMessage params:params Token:YES success:^(id responseObject) {
            NSDictionary *newUserMessage = responseObject[@"VO"];
            [userdefaluts setObject:newUserMessage forKey:wheatMalt_UserMessage];
            [userdefaluts synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
        } Target:self];
    }
}
@end
