//
//  IntelligenceBugdetailsViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "IntelligenceBugdetailsViewController.h"

#import "BugDetailsTableViewCell.h"
@interface IntelligenceBugdetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_BugdetailsTableView;
}
@end

@implementation IntelligenceBugdetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"用户类型"];
    
    _BugdetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _BugdetailsTableView.delegate = self;
    _BugdetailsTableView.dataSource = self;
    _BugdetailsTableView.backgroundColor = BaseBgColor;
    _BugdetailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _BugdetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_BugdetailsTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bugdetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BugDetailsIndet = @"BugDetailsIndet";
    BugDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BugDetailsIndet];
    if (cell == nil) {
        cell = [[BugDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BugDetailsIndet];
    }
    cell.dic = self.bugdetails[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
