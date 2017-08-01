//
//  HomeBatchOperationViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomeBatchOperationViewController.h"
#import "SelectPersonInChargeViewController.h"


#import "BatchOperationTableViewCell.h"
@interface HomeBatchOperationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    double _BatchOperationPage;
    double _BatchOperationPages;
    
    UIView *_BatchbottomView;
}
@property(nonatomic,assign)BOOL allChoose;
@property(nonatomic,assign)BOOL isChoose;
@property(nonatomic,strong)UITableView *BatchOperationTableView;
@property(nonatomic,strong)NSMutableArray *BatchOperationDataList;

@end

@implementation HomeBatchOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allChoose = NO;
    
    [self drawHomeBatchOperationUI];
    
    [self getHomeBatchOperationDataWithPage:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)getHomeBatchOperationDataWithPage:(int)page
{
    self.BatchOperationDataList = [NSMutableArray array];
    for (NSDictionary *dic in CustomerData) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:@NO forKey:@"isChoose"];
        [self.BatchOperationDataList addObject:mutDic];
    }
    [self.BatchOperationTableView reloadData];
}

#pragma mark - 绘制UI
- (void)drawHomeBatchOperationUI
{
    
    [self NavTitleWithText:@"批量操作"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_noChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
    
    
    self.BatchOperationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    self.BatchOperationTableView.backgroundColor = BaseBgColor;
    self.BatchOperationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.BatchOperationTableView.delegate = self;
    self.BatchOperationTableView.dataSource = self;
    self.BatchOperationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.BatchOperationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_BatchOperationPage ==_BatchOperationPages) {
            [self.BatchOperationTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _BatchOperationPage++;
                
                [self getHomeBatchOperationDataWithPage:_BatchOperationPage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [self.BatchOperationTableView reloadData];
                    if (_BatchOperationPage ==_BatchOperationPages) {
                        [self.BatchOperationTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [self.BatchOperationTableView.mj_footer endRefreshing];
                    }
                });
            });
        }
    }];
    
    [self.view addSubview:self.BatchOperationTableView];
    
    
    _BatchbottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64, KScreenWidth, 50)];
    _BatchbottomView.backgroundColor = [UIColor grayColor];
    _BatchbottomView.userInteractionEnabled = YES;
    [self.view addSubview:_BatchbottomView];
    
    UIButton *changePersonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changePersonButton.frame = CGRectMake(0, 0, KScreenWidth, 50);
    [changePersonButton setBackgroundColor:ButtonHColor];
    [changePersonButton setTitle:@"指定负责人" forState:UIControlStateNormal];
    changePersonButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [changePersonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changePersonButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [changePersonButton addTarget:self action:@selector(BatchchangePersonCharge) forControlEvents:UIControlEventTouchUpInside];
    [_BatchbottomView addSubview:changePersonButton];
    
}

#pragma mark - 按钮事件
/**
 批量指定负责人
 */
- (void)BatchchangePersonCharge
{
    SelectPersonInChargeViewController *SelectPersonInChargeVC = [[SelectPersonInChargeViewController alloc] init];
    SelectPersonInChargeVC.personInCharge = @{@"id":@"1",@"name":@"吴宗安"};
    SelectPersonInChargeVC.datalist = personData;
    SelectPersonInChargeVC.key = @"name";
    __weak HomeBatchOperationViewController *weakSelf = self;
    SelectPersonInChargeVC.changePersnInCharge = ^(NSDictionary *personMessage){
        //转义负责人
        for (int i = 0; i < weakSelf.BatchOperationDataList.count; i++) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.BatchOperationDataList[i]];
            [mutDic setObject:@NO forKey:@"isChoose"];
            [weakSelf.BatchOperationDataList replaceObjectAtIndex:i withObject:mutDic];
        }
        [BasicControls showAlertWithMsg:@"操作成功" addTarget:self];
        [weakSelf.BatchOperationTableView reloadData];
        weakSelf.isChoose = NO;
        weakSelf.allChoose = NO;
        [weakSelf bottomBatchViewAnimationWithShow:NO];
    };
    [self.navigationController pushViewController:SelectPersonInChargeVC animated:YES];
}

/**
 全选
 */
- (void)allchooseData
{
    _allChoose = !_allChoose;
    if (_allChoose) {
        for (int i = 0; i < self.BatchOperationDataList.count; i++) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:self.BatchOperationDataList[i]];
            [mutDic setObject:@YES forKey:@"isChoose"];
            [self.BatchOperationDataList replaceObjectAtIndex:i withObject:mutDic];
        }
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_allChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
        if (!_isChoose) {
            [self bottomBatchViewAnimationWithShow:YES];
        }
        _isChoose = YES;
    } else {
        for (int i = 0; i < self.BatchOperationDataList.count; i++) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:self.BatchOperationDataList[i]];
            [mutDic setObject:@NO forKey:@"isChoose"];
            [self.BatchOperationDataList replaceObjectAtIndex:i withObject:mutDic];
        }
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_noChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
        if (_isChoose) {
            [self bottomBatchViewAnimationWithShow:NO];
        }
        _isChoose = NO;
    }
    [self.BatchOperationTableView reloadData];
    
}

#pragma mark - 动画
- (void)bottomBatchViewAnimationWithShow:(BOOL)show
{
    if (show) {
        [UIView animateWithDuration:.3 animations:^{
            _BatchbottomView.top -= 50;
        }];
        _BatchOperationTableView.height = KScreenHeight - 64 - 50;
    } else {
        _BatchOperationTableView.height = KScreenHeight - 64;
        [UIView animateWithDuration:.3 animations:^{
            _BatchbottomView.top += 50;
        }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *person = self.BatchOperationDataList[indexPath.row];
    person[@"isChoose"] = @(![person[@"isChoose"] boolValue]);
    
    if (!_isChoose == [BasicControls checkArrayDataWithDataList:self.BatchOperationDataList]) {
        [self bottomBatchViewAnimationWithShow:[BasicControls checkArrayDataWithDataList:self.BatchOperationDataList]];
    }
    
    NSMutableArray *choose = [NSMutableArray array];
    for (NSDictionary *dic in self.BatchOperationDataList) {
        [choose addObject:[dic valueForKey:@"isChoose"]];
    }
    if (![choose containsObject:@NO] && !_allChoose) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_allChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
        _allChoose = !_allChoose;

    }
    if ([choose containsObject:@NO] && _allChoose) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_noChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
        _allChoose = !_allChoose;
    }
    [tableView reloadData];
    _isChoose = [BasicControls checkArrayDataWithDataList:self.BatchOperationDataList];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.BatchOperationDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BatchOperationIdent = @"BatchOperationIdent";
    BatchOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BatchOperationIdent];
    if (cell == nil) {
        cell = [[BatchOperationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BatchOperationIdent];
    }
    
    cell.dic = self.BatchOperationDataList[indexPath.row];
    return cell;
}
@end
