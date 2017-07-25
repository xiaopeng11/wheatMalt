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
@interface IntelligenceChoosedViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_IntelligenceDatalist;
    UITableView *_IntelligenceTableView;
}

@end

@implementation IntelligenceChoosedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawIntelligenceChoosedUI];
    
    [self getIntelligenceChoosedData];
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
    choseParaLabel.clipsToBounds = YES;
    choseParaLabel.layer.cornerRadius = 15;
    [choseParaView addSubview:choseParaLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width + 5, 5, 20 , 20)];
    imageView.image = [UIImage imageNamed:@"timeRangeWrite"];
    [choseParaLabel addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToTimeRangeVC)];
    [choseParaLabel addGestureRecognizer:tap];
    
    
    _IntelligenceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 64 - 50) style:UITableViewStylePlain];
    _IntelligenceTableView.backgroundColor = BaseBgColor;
    _IntelligenceTableView.dataSource = self;
    _IntelligenceTableView.delegate = self;
    _IntelligenceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _IntelligenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_IntelligenceTableView];
}

#pragma mark - 获取数据
- (void)getIntelligenceChoosedData
{
    _IntelligenceDatalist = [NSMutableArray array];

    _IntelligenceDatalist = [BasicControls formatPriceStringInData:[BasicControls ConversiondateWithData:IntelligenceData] Keys:@[@"fl",@"je"]];
    
    [_IntelligenceTableView reloadData];
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
    PaymentRecordVC.intelligence = _IntelligenceDatalist[indexPath.row];
    [self.navigationController pushViewController:PaymentRecordVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _IntelligenceDatalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IntelligenceIndet = @"IntelligenceIndet";
    IntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligenceIndet];
    if (cell == nil) {
        cell = [[IntelligenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligenceIndet];
    }
    cell.dic = _IntelligenceDatalist[indexPath.row];
    return cell;
}


@end
