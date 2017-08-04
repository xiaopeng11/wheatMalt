//
//  HomeScreenViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "CustomerMessageViewController.h"
#import "PaymentRecordViewController.h"
#import "SpecificInformationViewController.h"


#import "CustomerTableViewCell.h"
#import "IntelligenceTableViewCell.h"
@interface HomeScreenViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *_HomeScreenDatalist;
    NSMutableArray *_recrntSearchDatalist;
    
    UIView *_RecentSearchView;
    UITableView *_RecentSearchTableView;
    
    NSString *_RecentSearchtext;
    
    int _recentDataPage;
    int _recentDataPages;
}
@property(nonatomic, strong)UISearchController *HomeScreenSearchController;
@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _recentDataPage = 1;
    _recentDataPages = 1;
    
    _HomeScreenDatalist = [NSMutableArray array];
    _recrntSearchDatalist = [NSMutableArray arrayWithArray:recentSearchKey];
    _RecentSearchtext = [NSString string];
    
    [self drawHomeScreenUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.HomeScreenSearchController.searchBar.hidden = NO;
    
    if (_RecentSearchtext.length != 0) {
        [self.HomeScreenSearchController setActive:YES];
        self.HomeScreenSearchController.searchBar.text = _RecentSearchtext;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.HomeScreenSearchController.searchBar isFirstResponder]) {
        [self.HomeScreenSearchController.searchBar resignFirstResponder];
    }
    self.HomeScreenSearchController.searchBar.hidden = YES;
    [self.HomeScreenSearchController setActive:NO];
}

#pragma mark - 获取数据
/**
 刷新
 */
- (void)refreshHomeScreenData
{
    [self getHomeScreenDataWithHead:YES];
}

- (void)getHomeScreenDataWithHead:(BOOL)head
{
    if (_HomeScreenDatalist.count == 0) {
        _RecentSearchTableView.hidden = YES;
        NoDataView *noRecentSearchView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) type:PlaceholderViewTypeNoSearchData delegate:self];
        [self.view addSubview:noRecentSearchView];
    } else {
        _RecentSearchTableView.hidden = NO;
        [_RecentSearchTableView.mj_footer endRefreshingWithNoMoreData];
        [_RecentSearchTableView reloadData];
    }
    
}

#pragma mark - 绘制UI
- (void)drawHomeScreenUI
{
    [self NavTitleWithText:@"筛选"];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    searchView.backgroundColor = BaseBgColor;
    [self.view addSubview:searchView];
    
    //搜索框
    self.HomeScreenSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.HomeScreenSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    self.HomeScreenSearchController.searchBar.delegate = self;
    self.HomeScreenSearchController.dimsBackgroundDuringPresentation = NO;
    self.HomeScreenSearchController.hidesNavigationBarDuringPresentation = NO;

    self.HomeScreenSearchController.searchBar.placeholder = @"搜索";
    [self.HomeScreenSearchController.searchBar sizeToFit];
    self.HomeScreenSearchController.searchBar.hidden = YES;
    //搜索框背景
    self.HomeScreenSearchController.searchBar.barTintColor = BaseBgColor;
    UIImageView *barImageView = [[[self.HomeScreenSearchController.searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = BaseBgColor.CGColor;
    barImageView.layer.borderWidth = 1;
    
    [searchView addSubview:self.HomeScreenSearchController.searchBar];
    
    _RecentSearchView = [[UIView alloc] initWithFrame:CGRectZero];
    _RecentSearchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_RecentSearchView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 30)];
    titleLabel.font = SmallFont;
    titleLabel.text = @"最近搜索";
    [_RecentSearchView addSubview:titleLabel];
    
    CGFloat totalwidth = 10;
    CGFloat nowheight = 50;
    for (int i = 0; i < _recrntSearchDatalist.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 31110 + i;
        button.layer.borderWidth = .5;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(recentSearchClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = SmallFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _recrntSearchDatalist[i];
        
        CGFloat labelwidth = [label sizeThatFits:CGSizeMake(0, 18)].width;
        label.frame = CGRectMake(20, 15, labelwidth, 18);
        
        totalwidth += labelwidth + 40 + 20;
        if (totalwidth > KScreenWidth + 10) {
            nowheight += 68;
            totalwidth = 10 + labelwidth + 40 + 20;
        }
        if (totalwidth == 10 + labelwidth + 40 + 20 && labelwidth > KScreenWidth - 20) {
            labelwidth = KScreenWidth - 20;
        }
        button.frame = CGRectMake(totalwidth - labelwidth - 40 - 20, nowheight, labelwidth + 40, 48);

        [button addSubview:label];
        [_RecentSearchView addSubview:button];
    }
    _RecentSearchView.frame = CGRectMake(0, 44, KScreenWidth, nowheight + 70);
    
    _RecentSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _RecentSearchTableView.backgroundColor = BaseBgColor;
    _RecentSearchTableView.dataSource = self;
    _RecentSearchTableView.delegate = self;
    _RecentSearchTableView.hidden = YES;
    _RecentSearchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _RecentSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _RecentSearchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _recentDataPage = 1;
            [self getHomeScreenDataWithHead:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_RecentSearchTableView.mj_header endRefreshing];
                if (_recentDataPage == _recentDataPages) {
                    [_RecentSearchTableView.mj_footer endRefreshingWithNoMoreData];
                }
            });
        });
    }];
    _RecentSearchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _recentDataPage++;
                [self getHomeScreenDataWithHead:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_recentDataPage == _recentDataPages) {
                        [_RecentSearchTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_RecentSearchTableView.mj_footer endRefreshing];
                    }
                });
            });
    }];

    [self.view addSubview:_RecentSearchTableView];

}

#pragma mark - 按钮事件
- (void)recentSearchClick:(UIButton *)button
{
    NSMutableArray *datas = [NSMutableArray array];
    [datas addObject:recentSearchKey[button.tag - 31110]];
    NSLog(@"%@",datas);
    SpecificInformationViewController *SpecificInformationVC = [[SpecificInformationViewController alloc] init];
    SpecificInformationVC.paras = [datas mutableCopy];
    [self.navigationController pushViewController:SpecificInformationVC animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_HomeScreenDatalist removeAllObjects];
    _RecentSearchTableView.hidden = YES;
    _RecentSearchView.hidden = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _RecentSearchtext = @"";
    _RecentSearchTableView.hidden = YES;
    _RecentSearchView.hidden = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _RecentSearchtext = searchBar.text;
    
    _RecentSearchView.hidden = YES;
    _HomeScreenDatalist = [BasicControls ConversiondateWithData:HomeRecentSearchData];
    if (_HomeScreenDatalist.count == 0) {
        _RecentSearchTableView.hidden = YES;
    } else {
        _RecentSearchTableView.hidden = NO;
        [_RecentSearchTableView reloadData];
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _HomeScreenDatalist[indexPath.section];
    if (![[dic allKeys] containsObject:@"enddate"]) {
        return 90;
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
    NSDictionary *dic = _HomeScreenDatalist[indexPath.section];
    if (![[dic allKeys] containsObject:@"enddate"]) {
        CustomerMessageViewController *CustomerMessageVC = [[CustomerMessageViewController alloc] init];
        CustomerMessageVC.customer = [dic mutableCopy];
        [self.navigationController pushViewController:CustomerMessageVC animated:YES];
    } else {
        PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
        PaymentRecordVC.intelligence = [dic mutableCopy];
        [self.navigationController pushViewController:PaymentRecordVC animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _HomeScreenDatalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _HomeScreenDatalist[indexPath.section];
    if (![[dic allKeys] containsObject:@"enddate"]) {
        CustomerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customerIndet"];
        }
        cell.dic = dic;
        return cell;
    } else {
        IntelligenceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"intelligenceIndet"];
        }
        cell.dic = dic;
        return cell;
    }
    
}

#pragma mark - PlaceholderViewDelegate
- (void)placeholderView:(NoDataView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender
{
    [self refreshHomeScreenData];
}

@end
