//
//  PersonViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PersonViewController.h"
#import "BaseNavigationController.h"
#import "LoadingViewController.h"

#import "UserMessageViewController.h"
#import "MyhomeViewController.h"

#import "CollectionCropViewController.h"
#import "ImportCropsViewController.h"

#import "MessageSettingViewController.h"
#import "AdviceViewController.h"
#import "ResetPasswordViewController.h"
#import "ShareViewController.h"

#import "perosonHeaderTableViewCell.h"
#import "PersonTableViewCell.h"
#import "MyTableViewCell.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_personTableView;
    NSMutableArray *_personDatalist;
}
@end

@implementation PersonViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeJEState) name:@"hideJE" object:nil];

    _personDatalist = [NSMutableArray arrayWithArray:@[
                                  @{@"总收益":@(0),@"待结算收益":@(0),@"已结算收益":@(0),@"hideJE":@"0"},
                                  @{},
                                  @{@"imageName":@"lead",@"name":@"肖鹏",@"head":@YES},
                                  @{},
                                  @{@"imageName":@"person_area",@"name":@"麦圈",@"warning":@(0)},
                                  @{},
                                  @{@"imageName":@"person_collect",@"name":@"收藏",@"showLine":@YES},
                                  @{@"imageName":@"person_big",@"name":@"重大事项"},
                                  @{},
                                  @{@"imageName":@"person_warning",@"name":@"消息设置",@"showLine":@YES},
                                  @{@"imageName":@"person_advice",@"name":@"意见反馈",@"showLine":@YES},
                                  @{@"imageName":@"person_resetps",@"name":@"修改密码",@"showLine":@YES},
                                  @{@"imageName":@"person_share",@"name":@"分享小麦芽"},
                                  @{},
                                  @{@"name":@"安全退出"},
                                  @{}]];
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    NSDictionary *persionset = [BasicControls dictionaryWithJsonString:[userMessage valueForKey:@"persionset"]];
    if ([[persionset valueForKey:@"cbflag"] intValue] == 1 || ![persionset.allKeys containsObject:@"cbflag"]) {
        [_personDatalist replaceObjectAtIndex:0 withObject:@{@"总收益":@(0),@"待结算收益":@(0),@"已结算收益":@(0),@"hideJE":@"1"}];
    }
    
    [self drawPersonUI];
    
    _GetPersontimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(getSQRNum) userInfo:nil repeats:YES];
    [_GetPersontimer setFireDate:[NSDate distantPast]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"person_navibg"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   
    [_GetPersontimer setFireDate:[NSDate distantPast]];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = TabbarColor;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [_GetPersontimer setFireDate:[NSDate distantFuture]];

}

/**
 获取申请人数量
 */
- (void)getSQRNum
{
    [HTTPRequestTool requestMothedWithPost:wheatMalt_GetSQRNum params:nil Token:YES success:^(id responseObject) {
        NSString *sqrNum = [NSString stringWithFormat:@"%@",responseObject[@"sqrs"]];
        NSMutableDictionary *warningDic = [NSMutableDictionary dictionaryWithDictionary:_personDatalist[4]];
        NSLog(@"金额:%@",sqrNum);
        if ([sqrNum longLongValue] != [warningDic[@"warning"] longLongValue]) {
            [warningDic setObject:sqrNum forKey:@"warning"];
            [_personDatalist replaceObjectAtIndex:4 withObject:warningDic];
            [_personTableView reloadData];
        }
    } failure:^(NSError *error) {
    } Target:nil];
}

#pragma mark - 绘制UI
- (void)drawPersonUI
{
    [self Nav2TitleWithText:@"我"];
    
    _personTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _personTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _personTableView.backgroundColor = BaseBgColor;
    _personTableView.delegate = self;
    _personTableView.dataSource = self;
    _personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _personTableView.showsVerticalScrollIndicator = NO;
    _personTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *userMessage = [userdefaults objectForKey:wheatMalt_UserMessage];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[NSString stringWithFormat:@"%@",[userMessage valueForKey:@"id"]] forKey:@"id"];
            
            [HTTPRequestTool requestMothedWithPost:wheatMalt_RefreshUserMessage params:params Token:YES success:^(id responseObject) {
                [_personTableView.mj_header endRefreshing];
                NSDictionary *userMessageed = responseObject[@"VO"];
                if ([[userMessageed objectForKey:@"isdelete"] intValue] == 1) {
                    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已被移除" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [userdefaults setObject:@NO forKey:wheatMalt_isLoading];
                        [userdefaults removeObjectForKey:wheatMalt_Tokenid];
                        [userdefaults removeObjectForKey:wheatMalt_UserMessage];
                        [userdefaults synchronize];
                        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[LoadingViewController alloc] init]];
                        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    }];
                    [alertcontroller addAction:okaction];
                    [self presentViewController:alertcontroller animated:YES completion:nil];

                } else {
                    [userdefaults setObject:userMessageed forKey:wheatMalt_UserMessage];
                    [userdefaults synchronize];
                    [_personTableView reloadData];
                }
            } failure:^(NSError *error) {
            } Target:nil];
        });
    }];
    [self.view addSubview:_personTableView];
}

#pragma mark - 通知事件
- (void)changeJEState
{
    NSMutableDictionary *jeDic = [NSMutableDictionary dictionaryWithDictionary:_personDatalist[0]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[jeDic valueForKey:@"hideJE"] isEqualToString:@"0"] ? [params setObject:@"1" forKey:@"flag"] : [params setObject:@"0" forKey:@"flag"];

    [HTTPRequestTool requestMothedWithPost:wheatMalt_HiddenJE params:params Token:YES success:^(id responseObject) {
        [[jeDic valueForKey:@"hideJE"] isEqualToString:@"0"] ? [jeDic setObject:@"1" forKey:@"hideJE"] : [jeDic setObject:@"0" forKey:@"hideJE"];
        [_personDatalist replaceObjectAtIndex:0 withObject:jeDic];
        [_personTableView reloadData];
    } failure:^(NSError *error) {
        
    } Target:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    } else if (indexPath.row == 2) {
        return 80;
    } else if (indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 14) {
        return 50;
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        UserMessageViewController *UserMessageVC = [[UserMessageViewController alloc] init];
        [self.navigationController pushViewController:UserMessageVC animated:YES];
    } else if (indexPath.row == 4) {
        MyhomeViewController *MyhomeVC = [[MyhomeViewController alloc] init];
        [self.navigationController pushViewController:MyhomeVC animated:YES];
    } else if (indexPath.row == 6) {
        CollectionCropViewController *CollectionCropVC = [[CollectionCropViewController alloc] init];
        [self.navigationController pushViewController:CollectionCropVC animated:YES];
    } else if (indexPath.row == 7) {
        ImportCropsViewController *ImportCropVC = [[ImportCropsViewController alloc] init];
        [self.navigationController pushViewController:ImportCropVC animated:YES];
    } else if (indexPath.row == 9) {
        MessageSettingViewController *MessageSettingVC = [[MessageSettingViewController alloc] init];
        [self.navigationController pushViewController:MessageSettingVC animated:YES];
    } else if (indexPath.row == 10) {
        AdviceViewController *AdviceVC = [[AdviceViewController alloc] init];
        [self.navigationController pushViewController:AdviceVC animated:YES];
    } else if (indexPath.row == 11) {
        ResetPasswordViewController *ResetPasswordVC = [[ResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:ResetPasswordVC animated:YES];
    } else if (indexPath.row == 12) {
        ShareViewController *ShareVC = [[ShareViewController alloc] init];
        [self.navigationController pushViewController:ShareVC animated:YES];
    } else if (indexPath.row == 14) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:@NO forKey:wheatMalt_isLoading];
        [userdefault removeObjectForKey:wheatMalt_Tokenid];
        [userdefault removeObjectForKey:wheatMalt_UserMessage];
        [userdefault synchronize];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[BaseNavigationController alloc]initWithRootViewController:[[LoadingViewController alloc] init]];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        perosonHeaderTableViewCell *cell = [[perosonHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"perosonHeaderident"];
        cell.dic = _personDatalist[indexPath.row];
        cell.selectionStyle = NO;
        return cell;
    } else if (indexPath.row == 2) {
        MyTableViewCell *cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myident"];
        cell.dic = _personDatalist[indexPath.row];
        return cell;
    } else if (indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 ) {
        static NSString *contentindet = @"contentindet";
        PersonTableViewCell *cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentindet];
        cell.dic = _personDatalist[indexPath.row];
        return cell;
    } else if (indexPath.row == 14){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondcell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [_personDatalist[indexPath.row] valueForKey:@"name"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondcell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = NO;
        return cell;
    }
}
@end
