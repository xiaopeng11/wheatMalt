//
//  HomeViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTimeRangeChooseViewController.h"
#import "HomePersonInChargeChooseViewController.h"
#import "SpecificInformationViewController.h"
#import "HomeScreenViewController.h"

#import "HomeTableViewCell.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_homeTbaleView;
    NSArray *_homeData;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _homeData = [NSArray arrayWithObjects:@{@"imageName":@"personincharge",@"title":@"负责人"},
                                          @{@"imageName":@"region",@"title":@"区域"},
                                          @{@"imageName":@"timerange",@"title":@"时间段"},
                                          @{@"imageName":@"undistributed",@"title":@"未分配"},
                 nil];
    
    [self drawHomeUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawHomeUI
{
    [self NavTitleWithText:@"麦田"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"search" highImageName:@"search" target:self action:@selector(searchClick)];
    
    _homeTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _homeTbaleView.backgroundColor = BaseBgColor;
    _homeTbaleView.delegate = self;
    _homeTbaleView.dataSource = self;
    _homeTbaleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _homeTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_homeTbaleView];
    
}

#pragma mark - 搜索事件
- (void)searchClick
{
    HomeScreenViewController *HomeScreenVC = [[HomeScreenViewController alloc] init];
    [self.navigationController pushViewController:HomeScreenVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        HomePersonInChargeChooseViewController *homePersonInChargeChooseVC = [[HomePersonInChargeChooseViewController alloc] init];
        homePersonInChargeChooseVC.chosePerson = YES;
        [self.navigationController pushViewController:homePersonInChargeChooseVC animated:YES];
    } else if (indexPath.row == 1) {
        HomePersonInChargeChooseViewController *homePersonInChargeChooseVC = [[HomePersonInChargeChooseViewController alloc] init];
        homePersonInChargeChooseVC.chosePerson = NO;
        [self.navigationController pushViewController:homePersonInChargeChooseVC animated:YES];
    } else if (indexPath.row == 2) {
        HomeTimeRangeChooseViewController *HomeTimeRangeChooseVC = [[HomeTimeRangeChooseViewController alloc] init];
        HomeTimeRangeChooseVC.superView = @"Home";
        [self.navigationController pushViewController:HomeTimeRangeChooseVC animated:YES];
    } else if (indexPath.row == 3) {
        SpecificInformationViewController *SpecificInformationVC = [[SpecificInformationViewController alloc] init];
        [self.navigationController pushViewController:SpecificInformationVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _homeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"homecellIdent"];
    if (homeCell == nil) {
        homeCell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homecellIdent"];
    }
    homeCell.dic = _homeData[indexPath.row];
    homeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return homeCell;
}
@end
