//
//  CustomerViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CustomerViewController.h"
#import "AddCustomerViewController.h"
#import "CustomerMessageViewController.h"

#import "CustomerTableViewCell.h"
#import "CustomerModel.h"
@interface CustomerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _CustomerPage;
    int _CustomerPages;
    NoDataView *_noCustomerDataView;
}

@property(nonatomic,strong)UITableView *CustomerTableView;
@property(nonatomic,strong)NSMutableArray *CustomerDatalist;
@end

@implementation CustomerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _CustomerPage = 1;
    _CustomerPages = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshCustomer" object:nil];
    
    [self drawCustomerUI];
    
    [self getCustomerDataWithRefresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏按钮事件
- (void)addKehu
{
    AddCustomerViewController *AddCustomerVC = [[AddCustomerViewController alloc] init];
    __weak CustomerViewController *weakSelf = self;
    AddCustomerVC.addNewCustomer = ^(NSDictionary *Customer) {
        [weakSelf getCustomerDataWithRefresh:YES];
    };
    [self.navigationController pushViewController:AddCustomerVC animated:YES];
}

#pragma mark - 绘制UI
- (void)drawCustomerUI
{
    [self NavTitleWithText:@"情报"];    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"新增" target:self action:@selector(addKehu)];
    
    _CustomerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _CustomerTableView.backgroundColor = BaseBgColor;
    _CustomerTableView.dataSource = self;
    _CustomerTableView.delegate = self;
    _CustomerTableView.hidden = YES;
    _CustomerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _CustomerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _CustomerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _CustomerPage = 1;
            [self getCustomerDataWithRefresh:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgress];
                //回调或者说是通知主线程刷新，
                [_CustomerTableView reloadData];
                [_CustomerTableView.mj_header endRefreshing];
            });
        });
    }];
    _CustomerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_CustomerPage == _CustomerPages) {
            [_CustomerTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _CustomerPage++;
                [self getCustomerDataWithRefresh:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [_CustomerTableView reloadData];
                    if (_CustomerPage == _CustomerPages) {
                        [_CustomerTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_CustomerTableView.mj_footer endRefreshing];
                    }
                });
            });
        }
    }];
    [self.view addSubview:_CustomerTableView];
    
    _noCustomerDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49)];
    _noCustomerDataView.showPlacerHolder = @"您还没有情报";
    _noCustomerDataView.hidden = YES;
    [self.view addSubview:_noCustomerDataView];
}

#pragma mark - 获取数据
/**
 刷新页面
 */
- (void)refreshData
{
    [self getCustomerDataWithRefresh:YES];
}

/**
 获取数据

 @param refresh 是否刷新
 */
- (void)getCustomerDataWithRefresh:(BOOL)refresh
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (refresh) {
        if (_CustomerDatalist.count > 10) {
            [para setObject:@(_CustomerDatalist.count) forKey:@"pageSize"];
        } else {
            [para setObject:@(10) forKey:@"pageSize"];
        }
    } else {
        [para setObject:@(10) forKey:@"pageSize"];
    }
    [para setObject:@(_CustomerPage) forKey:@"pageNo"];

    [HTTPRequestTool requestMothedWithPost:wheatMalt_Customer params:para Token:YES success:^(id responseObject) {
        if (refresh) {
            _CustomerDatalist = [CustomerModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]];
        } else {
            _CustomerDatalist = [[_CustomerDatalist arrayByAddingObjectsFromArray:[CustomerModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]] mutableCopy];
        }
        _CustomerPages = [[responseObject objectForKey:@"totalPages"] intValue];
        if (_CustomerDatalist.count == 0) {
            _CustomerTableView.hidden = YES;
            _noCustomerDataView.hidden = NO;
        } else {
            _noCustomerDataView.hidden = YES;
            _CustomerTableView.hidden = NO;
            [_CustomerTableView.mj_footer endRefreshingWithNoMoreData];
            [_CustomerTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } Target:self];
//    _CustomerDatalist = [NSMutableArray arrayWithArray:CustomerData];
//     [_CustomerTableView reloadData];
}

/**
 失效或者恢复情报
 
 @param Invalid 失效
 @param index 当前位置
 
 */
- (void)InvalidCustomer:(int)Invalid Index:(NSUInteger)index
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(Invalid) forKey:@"yxbz"];
    [para setObject:[NSString stringWithFormat:@"%@",[_CustomerDatalist[index] valueForKey:@"id"]] forKey:@"id"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_InvalidORRecoveryCustomer params:para Token:YES success:^(id responseObject){
        [self getCustomerDataWithRefresh:YES];
    } failure:^(NSError *error) {
    } Target:self];    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
    
    CustomerMessageViewController *CustomerMessageVC = [[CustomerMessageViewController alloc] init];
    CustomerMessageVC.customer = _CustomerDatalist[indexPath.section];
    [self.navigationController pushViewController:CustomerMessageVC animated:YES];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _CustomerDatalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customerIdent = @"customerIdent";
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerIdent];
    if (cell == nil) {
        cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerIdent];
    }
    cell.dic = _CustomerDatalist[indexPath.section];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *InvalidAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"失效" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self InvalidCustomer:1 Index:indexPath.section];
    }];
    InvalidAction.backgroundColor = [UIColor colorWithHexString:@"#efb336"];
    
    UITableViewRowAction *recoveryAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"恢复" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self InvalidCustomer:0 Index:indexPath.section];
    }];
    recoveryAction.backgroundColor = [UIColor colorWithHexString:@"#efb336"];
    
    
    if ([[_CustomerDatalist[indexPath.section] valueForKey:@"yxbz"] intValue] == 1) {
        return @[recoveryAction];
    } else {
        return @[InvalidAction];
    }
}

@end
