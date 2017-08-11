//
//  AdviceHistoryViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AdviceHistoryViewController.h"
#import "AdviceMessageViewController.h"
#import "AdviceHistoryTableViewCell.h"
@interface AdviceHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,PlaceholderViewDelegate>
{
    UITableView *_AdviceHistoryTableView;
    NSMutableArray *_AdviceHistoryDatalist;
}
@end

@implementation AdviceHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"反馈历史"];
    
    _AdviceHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _AdviceHistoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _AdviceHistoryTableView.backgroundColor = BaseBgColor;
    _AdviceHistoryTableView.delegate = self;
    _AdviceHistoryTableView.dataSource = self;
    _AdviceHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_AdviceHistoryTableView];
    
    [self getMyAdviceData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)getMyAdviceData
{
    [HTTPRequestTool requestMothedWithPost:wheatMalt_Advices params:nil Token:YES success:^(id responseObject) {
        _AdviceHistoryDatalist = responseObject[@"List"];
        if (_AdviceHistoryDatalist.count == 0) {
            _AdviceHistoryTableView.hidden = YES;
            NoDataView *noAdviceView = [[NoDataView alloc] initWithFrame:_AdviceHistoryTableView.frame type:PlaceholderViewTypeNoAdvice delegate:nil];
            [self.view addSubview:noAdviceView];
        } else {
            _AdviceHistoryTableView.hidden = NO;
            [_AdviceHistoryTableView reloadData];
        }
    } failure:^(NSError *error) {
        NoDataView *noAdviceNetView = [[NoDataView alloc] initWithFrame:_AdviceHistoryTableView.frame type:PlaceholderViewTypeNoAdvice delegate:self];
        [self.view addSubview:noAdviceNetView];
    } Target:self];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AdviceMessageViewController *AdviceMessageVC = [[AdviceMessageViewController alloc] init];
    NSDictionary *data = [BasicControls dictionaryWithJsonString:[_AdviceHistoryDatalist[indexPath.row] valueForKey:@"data"]];
    AdviceMessageVC.AdviceMessage = data;
    [self.navigationController pushViewController:AdviceMessageVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _AdviceHistoryDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *adviceHistoryident = @"adviceHistoryident";
    AdviceHistoryTableViewCell *advicecell = [tableView dequeueReusableCellWithIdentifier:adviceHistoryident];
    if (advicecell == nil) {
        advicecell = [[AdviceHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adviceHistoryident];
    }
    advicecell.dic = _AdviceHistoryDatalist[indexPath.row];
    advicecell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return advicecell;
}

- (void)placeholderView:(NoDataView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender
{
    [self getMyAdviceData];
}
@end
