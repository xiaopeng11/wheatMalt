//
//  SpecificInformationViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SpecificInformationViewController.h"
#import "WJItemsControlView.h"

#import "CustomerMessageViewController.h"
#import "PaymentRecordViewController.h"
#import "HomeBatchOperationViewController.h"

#import "CustomerTableViewCell.h"
#import "IntelligenceTableViewCell.h"

#import "CustomerModel.h"
#import "intelligenceModel.h"
@interface SpecificInformationViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    WJItemsControlView *_itemsControlView;   //眉头试图
    UIScrollView *_scrollView;               //首页滑动式图
    
    int _index;
    
    NSMutableDictionary *_searchPara;    // 搜索的参数
    NSString *_searchURL;   // 搜索的接口
}

@property(nonatomic,strong)NSArray *customerDataList;
@property(nonatomic,strong)NSArray *intelligenceDatalist;
@property(nonatomic,assign)int customerPage;
@property(nonatomic,assign)int customerPages;
@property(nonatomic,assign)int intelligencePage;
@property(nonatomic,assign)int intelligencePages;

@end

@implementation SpecificInformationViewController

- (NSArray *)customerDataList
{
    if (_customerDataList == nil) {
        _customerDataList = [NSArray array];
    }
    return _customerDataList;
}

- (NSArray *)intelligenceDatalist
{
    if (_intelligenceDatalist == nil) {
        _intelligenceDatalist = [NSArray array];
    }
    return _intelligenceDatalist;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _index = 0;
    _customerPage = 1;
    _intelligencePage = 1;
    
    _customerDataList = [NSArray array];
    _intelligenceDatalist = [NSArray array];
    
    _customerPages = 1;
    _intelligencePages = 1;
    
    _searchPara = [NSMutableDictionary dictionary];
    _searchURL = [NSString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSpecificInformationData) name:@"refreshIntelligence" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSpecificInformationData) name:@"refreshCustomer" object:nil];

    
    [self drawSpecificInformationUI];
    
    [self getSpecificInformationWithRefresh:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawSpecificInformationUI
{
    [self NavTitleWithText:@"信息"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"批量操作" target:self action:@selector(BatchOperation)];
    
    NSArray *array = @[@"情报",@"客户"];
    NSArray *page = @[@(_customerPage),@(_intelligencePage)];
    NSArray *pages = @[@(_customerPages),@(_intelligencePages)];
    //scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(KScreenWidth * array.count, KScreenHeight - 64);
    _scrollView.bounces = NO;
    for (int i = 0; i < array.count; i++) {
        UITableView *SpecificInformationTableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 45, KScreenWidth, KScreenHeight - 64 - 45) style:UITableViewStylePlain];
        SpecificInformationTableView.tag = 30000 + i;
        SpecificInformationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        SpecificInformationTableView.backgroundColor = BaseBgColor;
        SpecificInformationTableView.delegate = self;
        SpecificInformationTableView.dataSource = self;
        SpecificInformationTableView.hidden = YES;
        SpecificInformationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //添加上拉加载更多，下拉刷新
        SpecificInformationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (_index == 0) {
                    _customerPage = 1;
                } else {
                    _intelligencePage = 1;
                }
                [self getSpecificInformationWithRefresh:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [SpecificInformationTableView.mj_header endRefreshing];
                });
            });
        }];
        SpecificInformationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([page[_index] intValue] == [pages[_index] intValue]) {
                [SpecificInformationTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (_index == 0) {
                        _customerPage++;
                    } else {
                        _intelligencePage++;
                    }
                    [self getSpecificInformationWithRefresh:NO];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        if (_index == 0) {
                            if (_customerPage == _customerPages) {
                                [SpecificInformationTableView.mj_footer endRefreshingWithNoMoreData];
                            } else {
                                [SpecificInformationTableView.mj_footer endRefreshing];
                            }
                        } else {
                            if (_intelligencePage == _intelligencePages) {
                                [SpecificInformationTableView.mj_footer endRefreshingWithNoMoreData];
                            } else {
                                [SpecificInformationTableView.mj_footer endRefreshing];
                            }
                        }
                    });
                });
            }
        }];
        [_scrollView addSubview:SpecificInformationTableView];
    }
    
    [self.view addSubview:_scrollView];
    
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.itemWidth = KScreenWidth / 2.0;
    
    _itemsControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    _itemsControlView.tapAnimation = NO;
    _itemsControlView.backgroundColor = [UIColor whiteColor];
    _itemsControlView.config = config;
    _itemsControlView.titleArray = array;
    
    __weak typeof (_scrollView)weakScrollView = _scrollView;
    [_itemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_itemsControlView];
    
}

#pragma mark - 获取数据
/**
 获取数据

 @param refresh 是否刷新
 */
- (void)getSpecificInformationWithRefresh:(BOOL)refresh
{
    UITableView *tableview = (UITableView *)[_scrollView viewWithTag:30000 + _index];

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    NSMutableArray *nowData = _index == 0 ? [NSMutableArray arrayWithArray:_customerDataList] :[NSMutableArray arrayWithArray:_intelligenceDatalist];
    int nowPage = _index == 0 ? _customerPage : _intelligencePage;
    NSString *nowURL;
    if (self.searchLX == 0 || self.searchLX == 1) {
        nowURL = _index == 0 ? [NSString stringWithFormat:@"%@",wheatMalt_CustomerByids] : [NSString stringWithFormat:@"%@",wheatMalt_IntelligenceByids];
    } else if (self.searchLX == 2) {
        nowURL = _index == 0 ? [NSString stringWithFormat:@"%@",wheatMalt_Customer] : [NSString stringWithFormat:@"%@",wheatMalt_Intelligence];
    } else {
        nowURL = _index == 0 ? [NSString stringWithFormat:@"%@",wheatMalt_CustomerUndistribution] : [NSString stringWithFormat:@"%@",wheatMalt_IntelligenceUndistribution];
    }
    _searchURL = nowURL;
    
    //判断传进来的类型
    if (self.searchLX == 2) {
        if (self.paras.count == 1) {
            [para setObject:self.paras[0] forKey:@"fsrqq"];
            [para setObject:self.paras[0] forKey:@"fsrqz"];
        } else {
            [para setObject:self.paras[0] forKey:@"fsrqq"];
            [para setObject:self.paras[1] forKey:@"fsrqz"];
        }
        
    } else if (self.searchLX == 0 || self.searchLX == 1) {
        NSMutableArray *idORarea = [NSMutableArray array];
        for (NSDictionary *dic in self.paras) {
            [idORarea addObject:[dic valueForKey:@"id"]];
        }
        [para setObject:[idORarea componentsJoinedByString:@","] forKey:@"ids"];
    } 
    //分页参数
    if (refresh) {
        if (nowData.count > 10) {
            [para setObject:@(nowData.count) forKey:@"pageSize"];
        } else {
            [para setObject:@(10) forKey:@"pageSize"];
        }
    } else {
        [para setObject:@(10) forKey:@"pageSize"];
    }
    [para setObject:@(nowPage) forKey:@"pageNo"];
    
    _searchPara = para;
    
    [HTTPRequestTool requestMothedWithPost:nowURL params:para Token:YES success:^(id responseObject) {
        if (refresh) {
            if (_index == 0) {
                self.customerPages = [[responseObject objectForKey:@"totalPages"] intValue];
                self.customerDataList = [CustomerModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]];
                if (_customerPage == _customerPages) {
                    [tableview.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                self.intelligencePages = [[responseObject objectForKey:@"totalPages"] intValue];
                self.intelligenceDatalist = [intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]];
                if (_intelligencePage == _intelligencePages){
                    [tableview.mj_footer endRefreshingWithNoMoreData];
                }
            }
        } else {
            if (_index == 0) {
                self.customerDataList = [[self.customerDataList arrayByAddingObjectsFromArray:[CustomerModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]] mutableCopy];

            } else {
                self.intelligenceDatalist = [[self.intelligenceDatalist arrayByAddingObjectsFromArray:[intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]] mutableCopy];
            }
        }
        if (_index == 0) {
            if (self.customerDataList.count == 0) {
                NoDataView *noDataView = [[NoDataView alloc] initWithFrame:tableview.frame type:PlaceholderViewTypeNoSearchData delegate:self];
                [_scrollView addSubview:noDataView];
                tableview.hidden = YES;
            } else {
                tableview.hidden = NO;
                if ([[responseObject objectForKey:@"pageNo"] intValue] == [[responseObject objectForKey:@"totalPages"] intValue]) {
                    [tableview.mj_footer endRefreshingWithNoMoreData];
                }
                [tableview reloadData];
            }
        } else {
            if (self.intelligenceDatalist.count == 0) {
                NoDataView *noDataView = [[NoDataView alloc] initWithFrame:tableview.frame type:PlaceholderViewTypeNoSearchData delegate:self];
                [_scrollView addSubview:noDataView];
                tableview.hidden = YES;
            } else {
                tableview.hidden = NO;
                self.intelligenceDatalist  = [BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:self.intelligenceDatalist] Keys:@[@"je",@"fl"]];
                if ([[responseObject objectForKey:@"pageNo"] intValue] == [[responseObject objectForKey:@"totalPages"] intValue]) {
                    [tableview.mj_footer endRefreshingWithNoMoreData];
                }
                [tableview reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        NoDataView *noNetworkView = [[NoDataView alloc] initWithFrame:tableview.frame type:PlaceholderViewTypeNoNetwork delegate:self];
        [self.view addSubview:noNetworkView];
        tableview.hidden = YES;
    } Target:self];
}


#pragma mark - 按钮事件
/**
 批量操作
 */
- (void)BatchOperation
{
    if (_index == 0 && _customerDataList.count == 0) {
        [BasicControls showAlertWithMsg:@"没有情报数据可供操作" addTarget:self];
        return;
    }
    
    if (_index == 1 && _intelligenceDatalist.count == 0) {
        [BasicControls showAlertWithMsg:@"没有客户数据可供操作" addTarget:self];
        return;
    }
    HomeBatchOperationViewController *HomeBatchOperationVC = [[HomeBatchOperationViewController alloc] init];
    HomeBatchOperationVC.customer = _index == 0 ? YES : NO;
    HomeBatchOperationVC.Exitdatalist = _index == 0 ? [_customerDataList mutableCopy] : [_intelligenceDatalist mutableCopy];
    HomeBatchOperationVC.page = _index == 0 ? _customerPage : _intelligencePage;
    HomeBatchOperationVC.pages = _index == 0 ? _customerPages : _intelligencePages;
    HomeBatchOperationVC.paras = _searchPara;
    HomeBatchOperationVC.searchURL = _searchURL;
    [self.navigationController pushViewController:HomeBatchOperationVC animated:YES];
}

#pragma mark - 通知
/**
 刷新页面
 */
- (void)refreshSpecificInformationData
{
    [self getSpecificInformationWithRefresh:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        float offset = scrollView.contentOffset.x;
        offset = offset / KScreenWidth;
        _index = offset;
        if (_index == 0 && _customerDataList.count == 0) {
            [self getSpecificInformationWithRefresh:YES];
        }
        if (_index == 1 && _intelligenceDatalist.count == 0) {
            [self getSpecificInformationWithRefresh:YES];
        }
        
        [_itemsControlView moveToIndex:offset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        //滑动到指定位置
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        _index = offset;
        [_itemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - UITableViewDelegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 30000) {
        return 90;
    } else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 30000) {
        CustomerMessageViewController *CustomerMessageVC = [[CustomerMessageViewController alloc] init];
        CustomerMessageVC.customer = _customerDataList[indexPath.section];
        [self.navigationController pushViewController:CustomerMessageVC animated:YES];
    } else {
        PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
        PaymentRecordVC.intelligence = _intelligenceDatalist[indexPath.section];
        [self.navigationController pushViewController:PaymentRecordVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 30000) {
        return _customerDataList.count;
    } else {
        return _intelligenceDatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 30000) {
        static NSString *customerIndet = @"customerIndet";
        CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerIndet];
        if (cell == nil) {
            cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerIndet];
        }
        cell.dic = _customerDataList[indexPath.section];
        return cell;
    } else {
        static NSString *IntelligenceIndet = @"IntelligenceIndet";
        IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligenceIndet];
        if (cell == nil) {
            cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligenceIndet];
        }
        cell.dic = _intelligenceDatalist[indexPath.section];
        return cell;
    }
}

#pragma mark - PlaceholderViewDelegate
- (void)placeholderView:(NoDataView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender
{
    [self getSpecificInformationWithRefresh:YES];
}
@end
