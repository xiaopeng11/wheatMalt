//
//  ProfitViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ProfitViewController.h"

#import "ProfitTableViewCell.h"
@interface ProfitViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_ProfitTableView;
    NSMutableArray *_ProfitDataList;
    
    NSMutableArray *_selectProfitSection;
    NSMutableDictionary *_sectionDic;
}
@end

@implementation ProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sectionDic = [NSMutableDictionary dictionary];
    _selectProfitSection = [NSMutableArray array];
    
    [self drawProfitUI];
    
    [self getProfitData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawProfitUI
{
    if ([_lx isEqualToString:@"0"]) {
        [self NavTitleWithText:@"总收益"];
    } else if ([_lx isEqualToString:@"1"]) {
        [self NavTitleWithText:@"待结算收益"];
    } else {
        [self NavTitleWithText:@"已结算收益"];
    }
    
    _ProfitTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _ProfitTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _ProfitTableView.backgroundColor = BaseBgColor;
    _ProfitTableView.delegate = self;
    _ProfitTableView.dataSource = self;
    _ProfitTableView.hidden = YES;
    _ProfitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ProfitTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_ProfitTableView];
    
    
    NoDataView *noCropFunctionView = [[NoDataView alloc] initWithFrame:_ProfitTableView.frame type:PlaceholderViewTypeNoFunction delegate:nil];
    [self.view addSubview:noCropFunctionView];
}

#pragma mark - 获取数据
- (void)getProfitData
{
//    _ProfitDataList = [NSMutableArray arrayWithArray:ProfitData];
//    [_ProfitTableView reloadData];
}

#pragma mark - 单元格点击事件
- (void)leadProfitSectionData:(UIButton *)button
{
    NSString *string = [NSString stringWithFormat:@"%d",(int)button.tag - 51000];
    if ([_selectProfitSection containsObject:string]) {
        [_selectProfitSection removeObject:string];
        [_sectionDic removeObjectForKey:string];
        [_ProfitTableView reloadData];
        
    } else {
//        dispatch_group_t grouped = dispatch_group_create();
        
        [_selectProfitSection addObject:string];
//        NSMutableArray *sectionData = [NSMutableArray arrayWithArray:ProfitsectionData];
//        [_sectionDic setObject:sectionData forKey:string];
//        [self getProfitDataWithSection:string group:grouped];
//        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_ProfitTableView reloadData];
//        });
    }

}

- (void)getProfitDataWithSection:(NSString *)section
                           group:(dispatch_group_t)group
{
    dispatch_group_enter(group);
//    NSMutableArray *sectionData = [NSMutableArray arrayWithArray:ProfitsectionData];
//    [_sectionDic setObject:sectionData forKey:section];
    dispatch_group_leave(group);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = BaseBgColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [view addSubview:bgView];

    UILabel *intelligenceLabel = [[UILabel alloc] init];
    intelligenceLabel.font = LargeFont;
    intelligenceLabel.text = [NSString stringWithFormat:@"%@",[_ProfitDataList[section] valueForKey:@"name"]];
    [bgView addSubview:intelligenceLabel];
    
    CGFloat width = [intelligenceLabel sizeThatFits:CGSizeMake(0, 24)].width;
    intelligenceLabel.frame = CGRectMake(20, 13, width, 24);
    
    
    UILabel *StateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + width, 13, 60, 24)];
    StateLabel.font = SmallFont;
    if ([[_ProfitDataList[section] valueForKey:@"lx"] integerValue] == 1) {
        StateLabel.hidden = NO;
    } else {
        StateLabel.hidden = YES;
    }
    StateLabel.text = @"(未续费)";
    StateLabel.textColor = RedStateColor;
    [bgView addSubview:StateLabel];
    
    UILabel *moenyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + width + 70, 13, KScreenWidth - 90 - 34 - width, 24)];
    moenyLabel.font = LargeFont;
    moenyLabel.textColor = GreenStateColor;
    moenyLabel.textAlignment = NSTextAlignmentRight;
    NSString *moeny = [NSString stringWithFormat:@"%@",[_ProfitDataList[section] valueForKey:@"money"]];
    moenyLabel.text = [NSString stringWithFormat:@"￥%@",[moeny FormatPriceWithPriceString]];
    [bgView addSubview:moenyLabel];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 24, 21, 14, 8)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectProfitSection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"jiantou_a"];
    } else {
        selectView.image = [UIImage imageNamed:@"jiantou_b"];
    }
    [bgView addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, KScreenWidth, 50);
    button.tag = 51000 + section;
    [button addTarget:self action:@selector(leadProfitSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    return view;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _ProfitDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectProfitSection containsObject:string]) {
        NSArray *sectionArray = [_sectionDic objectForKey:string];
        return sectionArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *profitIndet = @"profitIndet";
    ProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profitIndet];
    if (cell == nil) {
        cell = [[ProfitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profitIndet];
    }
    if ([_selectProfitSection containsObject:indexStr]) {
        NSArray *array = [_sectionDic objectForKey:indexStr];
        cell.dic = array[indexPath.row];
    }
    cell.selectionStyle = NO;
    return cell;
}

@end
