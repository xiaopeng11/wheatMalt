//
//  IntelligenceChoosedViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IntelligenceChoosedViewController.h"
#import "PaymentRecordViewController.h"

#import "IntelligenceTableViewCell.h"
#import "intelligenceModel.h"
@interface IntelligenceChoosedViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_TimeRangeIntelligenceDatalist;
    UITableView *_TimeRangeIntelligenceTableView;
    
    int _TimeRangeIntelligencePage;
    int _TimeRangeIntelligencePages;
    
    NoDataView *_noTimeRangeIntelligenceView;

}

@end

@implementation IntelligenceChoosedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChooseIntelligenceData) name:@"refreshIntelligence" object:nil];

    [self drawIntelligenceChoosedUI];
    
    [self getTimeRangeIntelligenceDataWithRefresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawIntelligenceChoosedUI
{
    [self NavTitleWithText:@"客户"];
    
    UIView *choseParaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    choseParaView.userInteractionEnabled = YES;
    choseParaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:choseParaView];
    
    UILabel *choseParaLabel = [[UILabel alloc] init];
    choseParaLabel.userInteractionEnabled = YES;
    choseParaLabel.font = SmallFont;
    choseParaLabel.backgroundColor = BaseBgColor;

    if ([self.paras[0] isEqualToString:self.paras[1]]) {
        choseParaLabel.text = [NSString stringWithFormat:@"%@",self.paras[0]];
    } else {
        choseParaLabel.text = [NSString stringWithFormat:@"%@至%@",self.paras[0],self.paras[1]];
    }
    
    CGFloat width = [choseParaLabel sizeThatFits:CGSizeMake(0, 30)].width;
    choseParaLabel.frame = CGRectMake(10, 10, width + 30, 30);
    choseParaLabel.layer.cornerRadius = 15;
    [choseParaView addSubview:choseParaLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width + 5, 5, 20 , 20)];
    imageView.image = [UIImage imageNamed:@"timeRangeWrite"];
    [choseParaLabel addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToTimeRangeVC)];
    [choseParaLabel addGestureRecognizer:tap];
    
    _noTimeRangeIntelligenceView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 64 - 50)];
    _noTimeRangeIntelligenceView.hidden = YES;
    _noTimeRangeIntelligenceView.showPlacerHolder = @"未搜索到数据";
    [self.view addSubview:_noTimeRangeIntelligenceView];
    
    _TimeRangeIntelligenceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 64 - 50) style:UITableViewStylePlain];
    _TimeRangeIntelligenceTableView.backgroundColor = BaseBgColor;
    _TimeRangeIntelligenceTableView.dataSource = self;
    _TimeRangeIntelligenceTableView.delegate = self;
    _TimeRangeIntelligenceTableView.hidden = YES;
    _TimeRangeIntelligenceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _TimeRangeIntelligenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TimeRangeIntelligenceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self showProgress];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _TimeRangeIntelligencePage = 1;
            [self getTimeRangeIntelligenceDataWithRefresh:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgress];
                //回调或者说是通知主线程刷新，
                [_TimeRangeIntelligenceTableView reloadData];
                [_TimeRangeIntelligenceTableView.mj_header endRefreshing];
            });
        });
    }];
    _TimeRangeIntelligenceTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_TimeRangeIntelligencePage == _TimeRangeIntelligencePages) {
            [_TimeRangeIntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _TimeRangeIntelligencePage++;
                [self getTimeRangeIntelligenceDataWithRefresh:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [_TimeRangeIntelligenceTableView reloadData];
                    if (_TimeRangeIntelligencePage == _TimeRangeIntelligencePages) {
                        [_TimeRangeIntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_TimeRangeIntelligenceTableView.mj_footer endRefreshing];
                    }
                });
            });
        }
    }];
    [self.view addSubview:_TimeRangeIntelligenceTableView];
}

#pragma mark - 获取数据
/**
 刷新数据
 */
- (void)refreshChooseIntelligenceData
{
    [self getTimeRangeIntelligenceDataWithRefresh:YES];
}

/**
 获取数据
 
 @param refresh 是否刷新
 */
- (void)getTimeRangeIntelligenceDataWithRefresh:(BOOL)refresh
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (refresh) {
        if (_TimeRangeIntelligenceDatalist.count > 10) {
            [para setObject:@(_TimeRangeIntelligenceDatalist.count) forKey:@"pageSize"];
        } else {
            [para setObject:@(10) forKey:@"pageSize"];
        }
    } else {
        [para setObject:@(10) forKey:@"pageSize"];
    }
    [para setObject:@(_TimeRangeIntelligencePage) forKey:@"pageNo"];
    [para setObject:self.paras[0] forKey:@"fsrqq"];
    [para setObject:self.paras[1] forKey:@"fsrqz"];

    [HTTPRequestTool requestMothedWithPost:wheatMalt_Intelligence params:para Token:YES success:^(id responseObject) {
        if (refresh) {
            _TimeRangeIntelligenceDatalist = [intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]];
        } else {
            _TimeRangeIntelligenceDatalist = [[_TimeRangeIntelligenceDatalist arrayByAddingObjectsFromArray:[intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]] mutableCopy];
        }
        _TimeRangeIntelligenceDatalist  = [BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:_TimeRangeIntelligenceDatalist] Keys:@[@"je",@"fl"]];
        _TimeRangeIntelligencePage = [[responseObject objectForKey:@"totalPages"] intValue];
        if (_TimeRangeIntelligenceDatalist.count != 0) {
            _noTimeRangeIntelligenceView.hidden = YES;
            _TimeRangeIntelligenceTableView.hidden = NO;
            [_TimeRangeIntelligenceTableView.mj_footer endRefreshingWithNoMoreData];
            [_TimeRangeIntelligenceTableView reloadData];
        } else {
            _noTimeRangeIntelligenceView.hidden = NO;
            _TimeRangeIntelligenceTableView.hidden = YES;
        }
    } failure:^(NSError *error) {
        
    } Target:self];
    
    
}


#pragma mark - 返回日期选择页面
- (void)popToTimeRangeVC
{
    NSLog(@"asdasdas");
    [self.navigationController popViewControllerAnimated:YES];
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
    PaymentRecordVC.intelligence = _TimeRangeIntelligenceDatalist[indexPath.row];
    [self.navigationController pushViewController:PaymentRecordVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _TimeRangeIntelligenceDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IntelligenceIndet = @"IntelligenceIndet";
    IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligenceIndet];
    if (cell == nil) {
        cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligenceIndet];
    }
    cell.dic = _TimeRangeIntelligenceDatalist[indexPath.row];
    return cell;
}


@end
