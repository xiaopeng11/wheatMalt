//
//  IntelligenceViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IntelligenceViewController.h"

#import "PaymentRecordViewController.h"
#import "ChooseIntelligenceViewController.h"
#import "IntelligenceTableViewCell.h"

@interface IntelligenceViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_IntelligenceDatalist;
    UITableView *_IntelligenceTableView;
}
@end

@implementation IntelligenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self drawIntelligenceUI];
    
    [self getIntelligenceData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawIntelligenceUI
{
    [self NavTitleWithText:@"客户"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"筛选" target:self action:@selector(chooseIntelligence)];
    
    _IntelligenceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _IntelligenceTableView.backgroundColor = BaseBgColor;
    _IntelligenceTableView.dataSource = self;
    _IntelligenceTableView.delegate = self;
    _IntelligenceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _IntelligenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_IntelligenceTableView];
}

#pragma mark - 获取数据
- (void)getIntelligenceData
{
    _IntelligenceDatalist = [NSMutableArray array];
    _IntelligenceDatalist  = [BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:IntelligenceData] Keys:@[@"je",@"fl"]];
    [_IntelligenceTableView reloadData];
}

#pragma mark - 按钮事件
/**
 筛选客户
 */
- (void)chooseIntelligence
{
    ChooseIntelligenceViewController *ChooseIntelligenceVC = [[ChooseIntelligenceViewController alloc] init];
    [self.navigationController pushViewController:ChooseIntelligenceVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
    PaymentRecordVC.intelligence = _IntelligenceDatalist[indexPath.row];
    [self.navigationController pushViewController:PaymentRecordVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _IntelligenceDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IntelligenceIndet = @"IntelligenceIndet";
    IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligenceIndet];
    if (cell == nil) {
        cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligenceIndet];
    }
    cell.dic = _IntelligenceDatalist[indexPath.row];
    return cell;
}
@end
