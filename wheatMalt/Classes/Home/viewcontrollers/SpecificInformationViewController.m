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

#import "CustomerTableViewCell.h"
#import "IntelligenceTableViewCell.h"
@interface SpecificInformationViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    WJItemsControlView *_itemsControlView;   //眉头试图
    UIScrollView *_scrollView;               //首页滑动式图
    
    UITableView *_SpecificInformationTableView;
    NoDataView *_noDataView;
    
    int _index;
}

@property(nonatomic,strong)NSArray *customerDataList;
@property(nonatomic,strong)NSArray *intelligenceDatalist;
@property(nonatomic,assign)double customerPage;
@property(nonatomic,assign)double customerPages;
@property(nonatomic,assign)double intelligencePage;
@property(nonatomic,assign)double intelligencePages;

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
    
    _customerPages = 2;
    _intelligencePages = 2;
    
    [self drawSpecificInformationUI];
    
    [self getSpecificInformationDataWithType:0 Page:1];
    
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
    NSArray *nodataNames = @[@"无情报信息",@"无客户信息"];
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
//        SpecificInformationTableView.hidden = YES;
        //添加上拉加载更多，下拉刷新
        SpecificInformationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getSpecificInformationDataWithType:i Page:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [SpecificInformationTableView reloadData];
                    [SpecificInformationTableView.mj_header endRefreshing];
                });
            });
        }];
        SpecificInformationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([page[i] intValue] == [pages[i] intValue]) {
                [SpecificInformationTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (i == 0) {
                        _customerPage++;
                    } else {
                        _intelligencePage++;
                    }
                    [self getSpecificInformationDataWithType:i Page:[page[i] intValue] + 1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        [SpecificInformationTableView reloadData];
                        if (i == 0) {
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
        
        _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 45, KScreenWidth, KScreenHeight - 64 - 45)];
        _noDataView.showPlacerHolder = nodataNames[i];
        _noDataView.hidden = YES;
        _noDataView.tag = 30010 + i;
        [_scrollView addSubview:_noDataView];
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
- (void)getSpecificInformationDataWithType:(int)type Page:(int)page
{
    UITableView *tbaleview = (UITableView *)[_scrollView viewWithTag:30000 + type];
    if (type == 0) {
        _customerDataList = [_customerDataList arrayByAddingObjectsFromArray:CustomerData];
    } else {
        _intelligenceDatalist = [_intelligenceDatalist arrayByAddingObjectsFromArray:[BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:IntelligenceData] Keys:@[@"je",@"fl"]]];
    }
    [tbaleview reloadData];
}

#pragma mark - 按钮事件
- (void)BatchOperation
{
    NSLog(@"批量操作");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        float offset = scrollView.contentOffset.x;
        offset = offset / KScreenWidth;
        if (offset == 0) {
            [self getSpecificInformationDataWithType:offset Page:_customerPage];
        } else {
            [self getSpecificInformationDataWithType:offset Page:_intelligencePage];
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
        [_itemsControlView endMoveToIndex:offset];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 30000) {
        return 100;
    } else {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 30000) {
        CustomerMessageViewController *CustomerMessageVC = [[CustomerMessageViewController alloc] init];
        CustomerMessageVC.customer = _customerDataList[indexPath.row];
        [self.navigationController pushViewController:CustomerMessageVC animated:YES];
    } else {
        PaymentRecordViewController *PaymentRecordVC = [[PaymentRecordViewController alloc] init];
        PaymentRecordVC.intelligence = _intelligenceDatalist[indexPath.row];
        [self.navigationController pushViewController:PaymentRecordVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 30000) {
        return _customerDataList.count;
    } else {
        return _intelligenceDatalist.count;;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 30000) {
        static NSString *customerIndet = @"customerIndet";
        CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerIndet];
        if (cell == nil) {
            cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerIndet];
        }
        cell.dic = _customerDataList[indexPath.row];
        return cell;
    } else {
        static NSString *IntelligenceIndet = @"IntelligenceIndet";
        IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligenceIndet];
        if (cell == nil) {
            cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligenceIndet];
        }
        cell.dic = _intelligenceDatalist[indexPath.row];
        return cell;
    }
    
}
@end
