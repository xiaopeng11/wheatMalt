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
#import "CustomerModel.h"
#import "intelligenceModel.h"
@interface HomeBatchOperationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_BatchbottomView;
}
@property(nonatomic,assign)BOOL allChoose;
@property(nonatomic,assign)BOOL isChoose;
@property(nonatomic,strong)UITableView *BatchOperationTableView;

@end

@implementation HomeBatchOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allChoose = NO;
    
    
    [self drawHomeBatchOperationUI];

    for (int i = 0; i < self.Exitdatalist.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.Exitdatalist[i]];
        [dic setObject:@NO forKey:@"isChoose"];
        [self.Exitdatalist replaceObjectAtIndex:i withObject:dic];
    }
    [self.BatchOperationTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)getHomeBatchOperationMoreData
{
    _page++;
    [self.paras setObject:@(10) forKey:@"pageSize"];
    [self.paras setObject:@(_page) forKey:@"pageNo"];
    [HTTPRequestTool requestMothedWithPost:self.searchURL params:self.paras Token:YES success:^(id responseObject) {
        self.pages = [[responseObject objectForKey:@"totalPages"] intValue];
        NSMutableArray *resultData = [NSMutableArray array];
        if (self.customer) {
            [resultData addObjectsFromArray:[CustomerModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]];
        } else {
            [resultData addObjectsFromArray:[intelligenceModel mj_keyValuesArrayWithObjectArray:[responseObject objectForKey:@"rows"]]];
        }
        
        for (int i = 0; i < resultData.count; i++) {
            NSMutableDictionary *mutdic = [NSMutableDictionary dictionaryWithDictionary:resultData[i]];
            [mutdic setObject:@NO forKey:@"isChoose"];
            [resultData replaceObjectAtIndex:i withObject:mutdic];
        }
        self.Exitdatalist = [[self.Exitdatalist arrayByAddingObjectsFromArray:resultData] mutableCopy];
        if (self.page == self.pages) {
            [self.BatchOperationTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.BatchOperationTableView reloadData];
    } failure:^(NSError *error) {
    } Target:self];
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
        if (self.page == self.pages) {
            [self.BatchOperationTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.BatchOperationTableView.mj_footer resetNoMoreData];

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getHomeBatchOperationMoreData];
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
    SelectPersonInChargeVC.personInCharge = @{@"id":@"",@"name":@""};
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *chargepersonData = [userdefault objectForKey:wheatMalt_ChargePersonData];
    SelectPersonInChargeVC.datalist = chargepersonData;
    SelectPersonInChargeVC.key = @"name";
    SelectPersonInChargeVC.canConsloe = YES;

    __weak HomeBatchOperationViewController *weakSelf = self;
    SelectPersonInChargeVC.changePersnInCharge = ^(NSDictionary *personMessage){
        NSMutableArray *msgs = [NSMutableArray array];
        for (NSDictionary *dic in weakSelf.Exitdatalist) {
            if ([[dic valueForKey:@"isChoose"] boolValue] == YES) {
                [msgs addObject:[dic valueForKey:@"id"]];
            }
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[msgs componentsJoinedByString:@","] forKey:@"ids"];
        [param setObject:[personMessage valueForKey:@"id"] forKey:@"usrid"];
        
        NSString *homeBatchURL;
        homeBatchURL = weakSelf.customer == YES ? wheatMalt_CustomerChargePerson : wheatMalt_IntelligenceChargePerson;
        [HTTPRequestTool requestMothedWithPost:homeBatchURL params:param Token:YES success:^(id responseObject) {
            [BasicControls showNDKNotifyWithMsg:@"修改负责人成功" WithDuration:1 speed:1];
            //转移负责人
            for (int i = 0; i < weakSelf.Exitdatalist.count; i++) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.Exitdatalist[i]];
                [mutDic setObject:@NO forKey:@"isChoose"];
                [weakSelf.Exitdatalist replaceObjectAtIndex:i withObject:mutDic];
            }
            [weakSelf.BatchOperationTableView reloadData];
            weakSelf.isChoose = NO;
            if (weakSelf.allChoose) {
                weakSelf.allChoose = NO;
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_noChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
            }
            [weakSelf bottomBatchViewAnimationWithShow:NO];
        } failure:^(NSError *error) {
        } Target:nil];
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
        for (int i = 0; i < self.Exitdatalist.count; i++) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:self.Exitdatalist[i]];
            [mutDic setObject:@YES forKey:@"isChoose"];
            [self.Exitdatalist replaceObjectAtIndex:i withObject:mutDic];
        }
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"home_allChoose" highImageName:@"home_noChoose" target:self action:@selector(allchooseData)];
        if (!_isChoose) {
            [self bottomBatchViewAnimationWithShow:YES];
        }
        _isChoose = YES;
    } else {
        for (int i = 0; i < self.Exitdatalist.count; i++) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:self.Exitdatalist[i]];
            [mutDic setObject:@NO forKey:@"isChoose"];
            [self.Exitdatalist replaceObjectAtIndex:i withObject:mutDic];
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
    NSMutableDictionary *person = self.Exitdatalist[indexPath.row];
    person[@"isChoose"] = @(![person[@"isChoose"] boolValue]);
    
    if (!_isChoose == [BasicControls checkArrayDataWithDataList:self.Exitdatalist]) {
        [self bottomBatchViewAnimationWithShow:[BasicControls checkArrayDataWithDataList:self.Exitdatalist]];
    }
    
    NSMutableArray *choose = [NSMutableArray array];
    for (NSDictionary *dic in self.Exitdatalist) {
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
    _isChoose = [BasicControls checkArrayDataWithDataList:self.Exitdatalist];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Exitdatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BatchOperationIdent = @"BatchOperationIdent";
    BatchOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BatchOperationIdent];
    if (cell == nil) {
        cell = [[BatchOperationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BatchOperationIdent];
    }
    
    cell.dic = self.Exitdatalist[indexPath.row];
    return cell;
}
@end
