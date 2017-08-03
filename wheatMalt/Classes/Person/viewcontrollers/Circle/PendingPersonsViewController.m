//
//  PendingPersonsViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PendingPersonsViewController.h"
#import "PendingPersonMessageViewController.h"

#import "PendingPersonsTableViewCell.h"
@interface PendingPersonsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_PendingPersonsTableView;
    NSMutableArray *_PendingPersonsDataList;
}

@end

@implementation PendingPersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"申请记录"];
    
    _PendingPersonsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _PendingPersonsTableView.backgroundColor = BaseBgColor;
    _PendingPersonsTableView.delegate = self;
    _PendingPersonsTableView.dataSource = self;
    _PendingPersonsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _PendingPersonsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_PendingPersonsTableView];
    
    [self getPendingPersonsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)getPendingPersonsData
{
    _PendingPersonsDataList = [NSMutableArray arrayWithArray:PendingPersonsData];
    [_PendingPersonsTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PendingPersonMessageViewController *PendingPersonMessageVC = [[PendingPersonMessageViewController alloc] init];
    PendingPersonMessageVC.personMessage = _PendingPersonsDataList[indexPath.row];
    PendingPersonMessageVC.touchView = self.touchView;
    [self.navigationController pushViewController:PendingPersonMessageVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    headerview.backgroundColor = TabbarColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KScreenWidth - 40, 30)];
    label.font = [UIFont systemFontOfSize:18];
    label.text = self.prince;
    [headerview addSubview:label];
    return headerview;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _PendingPersonsDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PendingPersonsindet = @"PendingPersonsindet";
    PendingPersonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PendingPersonsindet];
    if (cell == nil) {
        cell = [[PendingPersonsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PendingPersonsindet];
    }
    cell.dic = _PendingPersonsDataList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
