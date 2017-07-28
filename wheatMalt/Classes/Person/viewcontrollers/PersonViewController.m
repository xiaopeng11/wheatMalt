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

#import "MessageSettingViewController.h"
#import "AdviceViewController.h"
#import "ResetPasswordViewController.h"


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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeJEState) name:@"hideJE" object:nil];

    _personDatalist = [NSMutableArray arrayWithArray:@[
                                  @{@"总收益":@(40000),@"待结算收益":@(4000),@"已结算收益":@(36000),@"hideJE":@"NO"},
                                  @{},
                                  @{@"imageName":@"lead",@"name":@"肖鹏",@"head":@YES},
                                  @{},
                                  @{@"imageName":@"person_area",@"name":@"麦圈",@"warning":@(30)},
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
    
    [self drawPersonUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = TabbarColor;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

#pragma mark - 绘制UI
- (void)drawPersonUI
{
    [self Nav2TitleWithText:@"我"];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"image01"] forBarMetrics:UIBarMetricsDefault];
    _personTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _personTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _personTableView.backgroundColor = BaseBgColor;
    _personTableView.delegate = self;
    _personTableView.dataSource = self;
    _personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _personTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_personTableView];

    
}

#pragma mark - 通知事件
- (void)changeJEState
{
    NSMutableDictionary *jeDic = [NSMutableDictionary dictionaryWithDictionary:_personDatalist[0]];
    [[jeDic valueForKey:@"hideJE"] isEqualToString:@"NO"] ? [jeDic setObject:@"YES" forKey:@"hideJE"] : [jeDic setObject:@"NO" forKey:@"hideJE"];
    [_personDatalist replaceObjectAtIndex:0 withObject:jeDic];
    [_personTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 210;
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
        NSLog(@"收藏");
    } else if (indexPath.row == 7) {
        NSLog(@"重大事项");
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
        NSLog(@"分享小麦芽");
    } else if (indexPath.row == 14) {
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
