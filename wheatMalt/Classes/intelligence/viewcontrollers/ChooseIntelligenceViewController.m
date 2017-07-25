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

@interface ChooseIntelligenceViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSArray *_ChooseDatalist;
    NSMutableArray *_ChooseIntelligenceDatalist;
    
    UITableView *_ChooseIntelligenceTableView;
    NoDataView *_noChooseIntelligenceView;
    
    UITableView *_ChooseTableView;
    
    NSString *_text;
}
@property(nonatomic, strong)UISearchController *ChooseIntelligenceSearchController;

@end

@implementation ChooseIntelligenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _text = [NSString string];
    
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
    [self.view addSubview:_ChooseIntelligenceTableView];
    
    _noChooseIntelligenceView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
    _noChooseIntelligenceView.hidden = YES;
    _noChooseIntelligenceView.showPlacerHolder = @"未搜索到数据";
    [self.view addSubview:_noChooseIntelligenceView];
    
    _ChooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _ChooseTableView.backgroundColor = BaseBgColor;
    _ChooseTableView.dataSource = self;
    _ChooseTableView.delegate = self;
    _ChooseTableView.hidden = NO;
    _ChooseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _ChooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_ChooseTableView];    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_ChooseIntelligenceDatalist removeAllObjects];
    _ChooseTableView.hidden = YES;
    _ChooseIntelligenceTableView.hidden = YES;
    _noChooseIntelligenceView.hidden = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _text = @"";
    _ChooseTableView.hidden = NO;
    _ChooseIntelligenceTableView.hidden = YES;
    _noChooseIntelligenceView.hidden = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _text = searchBar.text;
    
    _ChooseTableView.hidden = YES;
    _ChooseIntelligenceDatalist = [BasicControls ConversiondateWithData:IntelligenceData];
    if (_ChooseIntelligenceDatalist.count == 0) {
        _ChooseIntelligenceTableView.hidden = YES;
        _noChooseIntelligenceView.hidden = NO;
    } else {
        _noChooseIntelligenceView.hidden = YES;
        _ChooseIntelligenceTableView.hidden = NO;
        [_ChooseIntelligenceTableView reloadData];
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_ChooseTableView]) {
        return 50;
    } else {
        return 80;
    }
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
        PaymentRecordVC.intelligence = _ChooseIntelligenceDatalist[indexPath.row];
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
        cell.dic = _ChooseIntelligenceDatalist[indexPath.row];
        return cell;
    }
    
}


@end
