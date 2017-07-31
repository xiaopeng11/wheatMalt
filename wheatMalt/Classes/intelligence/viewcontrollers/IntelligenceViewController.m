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

#import "intelligenceModel.h"
@interface IntelligenceViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_IntelligenceDatalist;
    UITableView *_IntelligenceTableView;
    
    int _IntelligencePage;
    int _IntelligencePages;
}
@end

@implementation IntelligenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _IntelligencePage = 1;
    _IntelligencePages = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIntelligenceData) name:@"refreshIntelligence" object:nil];
    
    [self drawIntelligenceUI];
    
    [self getIntelligenceDataWithRefresh:YES];
    
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
    _IntelligenceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self showProgress];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _IntelligencePage = 1;
            [self getIntelligenceDataWithRefresh:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgress];
                //回调或者说是通知主线程刷新，
                [_IntelligenceTableView reloadData];
                [_IntelligenceTableView.mj_header endRefreshing];
            });
        });
    }];
    _IntelligenceTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_IntelligencePage == _IntelligencePages) {
            [_IntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _IntelligencePage++;
                [self getIntelligenceDataWithRefresh:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [_IntelligenceTableView reloadData];
                    if (_IntelligencePage == _IntelligencePages) {
                        [_IntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_IntelligenceTableView.mj_footer endRefreshing];
                    }
                });
            });
        }
    }];
    [self.view addSubview:_IntelligenceTableView];
}

#pragma mark - 获取数据
/**
 刷新
 */
- (void)refreshIntelligenceData
{
    [self getIntelligenceDataWithRefresh:YES];
}

/**
 获取数据

 @param refresh 是否刷新
 */
- (void)getIntelligenceDataWithRefresh:(BOOL)refresh
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (refresh) {
        if (_IntelligenceDatalist.count > 10) {
            [para setObject:@(_IntelligenceDatalist.count) forKey:@"pageSize"];
        } else {
            [para setObject:@(10) forKey:@"pageSize"];
        }
    } else {
        [para setObject:@(10) forKey:@"pageSize"];
    }
    [para setObject:@(_IntelligencePage) forKey:@"pageNo"];
    
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Intelligence params:para Token:YES success:^(id responseObject) {
        if (refresh) {
            _IntelligenceDatalist = [intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]];
        } else {
            _IntelligenceDatalist = [[_IntelligenceDatalist arrayByAddingObjectsFromArray:[intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]] mutableCopy];
        }
        _IntelligenceDatalist  = [BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:_IntelligenceDatalist] Keys:@[@"je",@"fl"]];
        _IntelligencePages = [[responseObject objectForKey:@"totalPages"] intValue];
        [_IntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
        [_IntelligenceTableView reloadData];
    } failure:^(NSError *error) {
        
    } Target:self];
    
    
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
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    view.backgroundColor = BaseBgColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
    PaymentRecordVC.intelligence = _IntelligenceDatalist[indexPath.section];
    [self.navigationController pushViewController:PaymentRecordVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _IntelligenceDatalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IntelligenceIndet = @"IntelligenceIndet";
    IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligenceIndet];
    if (cell == nil) {
        cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligenceIndet];
    }
    cell.dic = _IntelligenceDatalist[indexPath.section];
    return cell;
}
@end
