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
    NoDataView *_noRecentSearchView;
    
    NSString *_RecentSearchtext;
}
@property(nonatomic, strong)UISearchController *HomeScreenSearchController;
@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.view addSubview:_RecentSearchTableView];
    
    _noRecentSearchView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
    _noRecentSearchView.hidden = YES;
    _noRecentSearchView.showPlacerHolder = @"未搜索到数据";
    [self.view addSubview:_noRecentSearchView];

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
    _noRecentSearchView.hidden = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _RecentSearchtext = @"";
    _RecentSearchTableView.hidden = YES;
    _RecentSearchView.hidden = NO;
    _noRecentSearchView.hidden = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _RecentSearchtext = searchBar.text;
    
    _RecentSearchView.hidden = YES;
    _HomeScreenDatalist = [BasicControls ConversiondateWithData:HomeRecentSearchData];
    if (_HomeScreenDatalist.count == 0) {
        _RecentSearchTableView.hidden = YES;
        _noRecentSearchView.hidden = NO;
    } else {
        _noRecentSearchView.hidden = YES;
        _RecentSearchTableView.hidden = NO;
        [_RecentSearchTableView reloadData];
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_HomeScreenDatalist[indexPath.row] valueForKey:@"msid"] isEqualToString:@"1"]) {
        return 100;
    } else {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[_HomeScreenDatalist[indexPath.row] valueForKey:@"msid"] isEqualToString:@"1"]) {
        CustomerMessageViewController *CustomerMessageVC = [[CustomerMessageViewController alloc] init];
        CustomerMessageVC.customer = _HomeScreenDatalist[indexPath.row];
        [self.navigationController pushViewController:CustomerMessageVC animated:YES];
    } else {
        PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
        PaymentRecordVC.intelligence = _HomeScreenDatalist[indexPath.row];
        [self.navigationController pushViewController:PaymentRecordVC animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _HomeScreenDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_HomeScreenDatalist[indexPath.row] valueForKey:@"msid"] isEqualToString:@"1"]) {
        CustomerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customerIndet"];
        }
        cell.dic = _HomeScreenDatalist[indexPath.row];
        return cell;
    } else {
        IntelligenceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"intelligenceIndet"];
        }
        cell.dic = _HomeScreenDatalist[indexPath.row];
        return cell;
    }
    
}



@end
