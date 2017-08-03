//
//  ChooseIntelligenceViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChooseIntelligenceViewController.h"
#import "PaymentRecordViewController.h"
#import "HomeTimeRangeChooseViewController.h"

#import "IntelligenceTableViewCell.h"
#import "ChoooseIntelligenceTableViewCell.h"

#import "intelligenceModel.h"
@interface ChooseIntelligenceViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PlaceholderViewDelegate>
{
    NSArray *_ChooseDatalist;
    NSMutableArray *_ChooseIntelligenceDatalist;
    
    UITableView *_ChooseIntelligenceTableView;
    
    UITableView *_ChooseTableView;
    
    NSString *_text;
    int _ChooseIntelligencePage;
    int _ChooseIntelligencePages;
}
@property(nonatomic, strong)UISearchController *ChooseIntelligenceSearchController;

@end

@implementation ChooseIntelligenceViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshIntelligence" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _text = [NSString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChooseIntelligenceData) name:@"refreshIntelligence" object:nil];

    [self drawChooseIntelligenceUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _ChooseIntelligenceSearchController.searchBar.hidden = NO;
    
    if (_text.length != 0) {
        [_ChooseIntelligenceSearchController setActive:YES];
        _ChooseIntelligenceSearchController.searchBar.text = _text;
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_ChooseIntelligenceSearchController.searchBar isFirstResponder]) {
        [_ChooseIntelligenceSearchController.searchBar resignFirstResponder];
    }
    _ChooseIntelligenceSearchController.searchBar.hidden = YES;
    [_ChooseIntelligenceSearchController setActive:NO];
}

#pragma mark - 绘制UI
- (void)drawChooseIntelligenceUI
{
    [self NavTitleWithText:@"筛选"];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    searchView.backgroundColor = BaseBgColor;
    [self.view addSubview:searchView];
    
    //搜索框
    _ChooseIntelligenceSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _ChooseIntelligenceSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
//    _ChooseIntelligenceSearchController.searchResultsUpdater = self;
    _ChooseIntelligenceSearchController.searchBar.delegate = self;
    _ChooseIntelligenceSearchController.dimsBackgroundDuringPresentation = NO;
    _ChooseIntelligenceSearchController.hidesNavigationBarDuringPresentation = NO;
//     self.definesPresentationContext = YES;
//    但hidesNavigationBarDuringPresentation设置为YES时正常，NO下移64
    _ChooseIntelligenceSearchController.searchBar.placeholder = @"搜索";
    [_ChooseIntelligenceSearchController.searchBar sizeToFit];
    _ChooseIntelligenceSearchController.searchBar.hidden = YES;
    //搜索框背景
    _ChooseIntelligenceSearchController.searchBar.barTintColor = BaseBgColor;
    UIImageView *barImageView = [[[_ChooseIntelligenceSearchController.searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = BaseBgColor.CGColor;
    barImageView.layer.borderWidth = 1;
    
    [searchView addSubview:_ChooseIntelligenceSearchController.searchBar];
    
    _ChooseIntelligenceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _ChooseIntelligenceTableView.backgroundColor = BaseBgColor;
    _ChooseIntelligenceTableView.dataSource = self;
    _ChooseIntelligenceTableView.delegate = self;
    _ChooseIntelligenceTableView.hidden = YES;
    _ChooseIntelligenceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _ChooseIntelligenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ChooseIntelligenceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _ChooseIntelligencePage = 1;
            [self getChooseIntelligenceDataWithRefresh:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_ChooseIntelligenceTableView.mj_header endRefreshing];
            });
        });
    }];
    _ChooseIntelligenceTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _ChooseIntelligencePage++;
                [self getChooseIntelligenceDataWithRefresh:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_ChooseIntelligencePage == _ChooseIntelligencePages) {
                        [_ChooseIntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_ChooseIntelligenceTableView.mj_footer endRefreshing];
                    }
                });
                
            });
    }];
    
    [self.view addSubview:_ChooseIntelligenceTableView];
    
    _ChooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _ChooseTableView.backgroundColor = BaseBgColor;
    _ChooseTableView.dataSource = self;
    _ChooseTableView.delegate = self;
    _ChooseTableView.hidden = NO;
    _ChooseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _ChooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_ChooseTableView];    
}
#pragma mark - 获取数据
/**
 刷新数据
 */
- (void)refreshChooseIntelligenceData
{
    [self getChooseIntelligenceDataWithRefresh:YES];
}

/**
 获取数据
 
 @param refresh 是否刷新
 */
- (void)getChooseIntelligenceDataWithRefresh:(BOOL)refresh
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (refresh) {
        if (_ChooseIntelligenceDatalist.count > 10) {
            [para setObject:@(_ChooseIntelligenceDatalist.count) forKey:@"pageSize"];
        } else {
            [para setObject:@(10) forKey:@"pageSize"];
        }
    } else {
        [para setObject:@(10) forKey:@"pageSize"];
    }
    [para setObject:@(_ChooseIntelligencePage) forKey:@"pageNo"];
    [para setObject:_text forKey:@"gsname"];
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Intelligence params:para Token:YES success:^(id responseObject) {
        if (refresh) {
            _ChooseIntelligenceDatalist = [intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]];
            if (_ChooseIntelligencePage == _ChooseIntelligencePages) {
                [_ChooseIntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            _ChooseIntelligenceDatalist = [[_ChooseIntelligenceDatalist arrayByAddingObjectsFromArray:[intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]] mutableCopy];
        }
        if (_ChooseIntelligenceDatalist.count != 0) {
            _ChooseIntelligenceDatalist  = [BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:_ChooseIntelligenceDatalist] Keys:@[@"je",@"fl"]];
            _ChooseIntelligencePages = [[responseObject objectForKey:@"totalPages"] intValue];
            _ChooseIntelligenceTableView.hidden = NO;
            [_ChooseIntelligenceTableView reloadData];
        } else {
            _ChooseIntelligenceTableView.hidden = YES;
            NoDataView *noChooseIntelligenceView = [[NoDataView alloc] initWithFrame:_ChooseIntelligenceTableView.frame type:PlaceholderViewTypeNoSearchData delegate:self];
            [self.view addSubview:noChooseIntelligenceView];
        }
    } failure:^(NSError *error) {
        
    } Target:self];
    
    
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_ChooseIntelligenceDatalist removeAllObjects];
    _ChooseTableView.hidden = YES;
    _ChooseIntelligenceTableView.hidden = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _text = @"";
    _ChooseTableView.hidden = NO;
    _ChooseIntelligenceTableView.hidden = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _text = searchBar.text;
    
    _ChooseTableView.hidden = YES;
    _ChooseIntelligenceDatalist = [BasicControls ConversiondateWithData:IntelligenceData];
    [self getChooseIntelligenceDataWithRefresh:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_ChooseTableView]) {
        return 50;
    } else {
        return 70;
    }
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
    if ([tableView isEqual:_ChooseTableView]) {
        HomeTimeRangeChooseViewController *HomeTimeRangeChooseVC = [[HomeTimeRangeChooseViewController alloc] init];
        HomeTimeRangeChooseVC.superView = @"ChooseIntelligence";
        [self.navigationController pushViewController:HomeTimeRangeChooseVC animated:YES];
    } else {
        PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
        PaymentRecordVC.intelligence = _ChooseIntelligenceDatalist[indexPath.section];
        [self.navigationController pushViewController:PaymentRecordVC animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_ChooseTableView]) {
        return 1;
    } else {
        return _ChooseIntelligenceDatalist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_ChooseTableView]) {
        static NSString *ChooseIndet = @"ChooseIndet";
        ChoooseIntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseIndet];
        if (cell == nil) {
            cell = [[ChoooseIntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChooseIndet];
        }
        return cell;
    } else {
        static NSString *ChooseIntelligenceIndet = @"ChooseIntelligenceIndet";
        IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseIntelligenceIndet];
        if (cell == nil) {
            cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChooseIntelligenceIndet];
        }
        cell.dic = _ChooseIntelligenceDatalist[indexPath.section];
        return cell;
    }
    
}

#pragma mark - PlaceholderViewDelegate
- (void)placeholderView:(NoDataView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender
{
    [self refreshChooseIntelligenceData];
}

@end
