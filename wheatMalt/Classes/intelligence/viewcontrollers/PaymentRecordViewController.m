//
//  PaymentRecordViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PaymentRecordViewController.h"
#import "IntelligenceMessageViewController.h"


#import "PaymentRecordTableViewCell.h"

@interface PaymentRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_PaymentRecordTableView;
    NSMutableArray *_PaymentRecordDatalist;
}
@end

@implementation PaymentRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawPaymentRecordUI];
    
    [self getPaymentRecordData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawPaymentRecordUI
{
    [self NavTitleWithText:@"付款记录"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"详情" target:self action:@selector(IntelligenceMessage)];
    
    _PaymentRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _PaymentRecordTableView.backgroundColor = BaseBgColor;
    _PaymentRecordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _PaymentRecordTableView.sectionHeaderHeight = 100;
    _PaymentRecordTableView.delegate = self;
    _PaymentRecordTableView.dataSource = self;
    _PaymentRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_PaymentRecordTableView];
}

#pragma mark - 获取数据
- (void)getPaymentRecordData
{
    _PaymentRecordDatalist = [NSMutableArray array];
    _PaymentRecordDatalist = [BasicControls formatPriceStringInData:[PaymentRecordData mutableCopy] Keys:@[@"je",@"fl"]];
    [_PaymentRecordTableView reloadData];
}

#pragma mark - 按钮事件
/**
 客户详情
 */
- (void)IntelligenceMessage
{
    IntelligenceMessageViewController *IntelligenceMessageVC = [[IntelligenceMessageViewController alloc] init];
    IntelligenceMessageVC.Intelligence = self.intelligence;
    [self.navigationController pushViewController:IntelligenceMessageVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    headerView.backgroundColor = BaseBgColor;
    [view addSubview:headerView];
    
    UILabel *intelligenceName = [[UILabel alloc] init];
    intelligenceName.font = [UIFont boldSystemFontOfSize:18];
    intelligenceName.text = [self.intelligence valueForKey:@"name"];
    [view addSubview:intelligenceName];
    
    CGFloat nameWidth = [intelligenceName sizeThatFits:CGSizeMake(0, 40)].width;
    
    UILabel *state = [[UILabel alloc] init];
    state.font = SmallFont;
    [view addSubview:state];

    if ([[self.intelligence valueForKey:@"lx"] integerValue] == 0) {
        state.textColor = [UIColor colorWithHexString:@"#23d923"];
        state.text = @"  (使用中)";
    } else {
        state.textColor = [UIColor redColor];
        state.text = @"  (未续费已停用)";
    }
    
    CGFloat stateWidth = [state sizeThatFits:CGSizeMake(0, 40)].width;
    
    intelligenceName.frame = CGRectMake((KScreenWidth - nameWidth - stateWidth) / 2, 10, nameWidth, 40);
    state.frame = CGRectMake(((KScreenWidth - nameWidth - stateWidth) / 2) + nameWidth, 10, stateWidth, 40);

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 40)];
    timeLabel.text = @"付款时间";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:timeLabel];
    
    UILabel *jeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, (KScreenWidth - 120) / 2, 40)];
    jeLabel.text = @"金额";
    jeLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:jeLabel];
    
    UILabel *flLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 + ((KScreenWidth - 120) / 2), 60, (KScreenWidth - 120) / 2, 40)];
    flLabel.text = @"返利";
    flLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:flLabel];
    
    UIView *view3 = [BasicControls drawLineWithFrame:CGRectMake(0, 99.5, KScreenWidth, .5)];
    [view addSubview:view3];
    
    return view;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _PaymentRecordDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PaymentRecordindet = @"PaymentRecordindet";
    PaymentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PaymentRecordindet];
    if (cell == nil) {
        cell = [[PaymentRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PaymentRecordindet];
    }
    cell.dic = _PaymentRecordDatalist[indexPath.row];
    cell.userInteractionEnabled = NO;
    return cell;
}

@end
