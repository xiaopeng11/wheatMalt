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
@interface AdviceHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
//    _AdviceHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
//    _AdviceHistoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    _AdviceHistoryTableView.backgroundColor = BaseBgColor;
//    _AdviceHistoryTableView.delegate = self;
//    _AdviceHistoryTableView.dataSource = self;
//    _AdviceHistoryTableView.hidden = YES;
//    _AdviceHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_AdviceHistoryTableView];
    
    NoDataView *noCollectionCropView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) type:PlaceholderViewTypeNoFunction delegate:nil];
    [self.view addSubview:noCollectionCropView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    AdviceMessageVC.AdviceMessage = _AdviceHistoryDatalist[indexPath.row];
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
@end
