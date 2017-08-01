//
//  HomePersonInChargeChooseViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HomePersonInChargeChooseViewController.h"
#import "SpecificInformationViewController.h"

#import "PersonInChargeTableViewCell.h"
@interface HomePersonInChargeChooseViewController ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>

@property(nonatomic,assign)BOOL isChoose;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSMutableArray *PersonInChargeData;
@property(nonatomic,strong)UITableView *HomePersonInChargeChooseTableView;
@end

@implementation HomePersonInChargeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _PersonInChargeData = [NSMutableArray array];
    
    [self getPersonInChargeData];
    
    [self drawHomePersonInChargeChooseUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 绘制UI
- (void)drawHomePersonInChargeChooseUI
{
    self.chosePerson ? [self NavTitleWithText:@"负责人"] : [self NavTitleWithText:@"区域"];
        
    _HomePersonInChargeChooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _HomePersonInChargeChooseTableView.backgroundColor = BaseBgColor;
    _HomePersonInChargeChooseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _HomePersonInChargeChooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HomePersonInChargeChooseTableView.delegate = self;
    _HomePersonInChargeChooseTableView.dataSource = self;
    [self.view addSubview:_HomePersonInChargeChooseTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64, KScreenWidth, 50)];
    _bottomView.backgroundColor = ButtonHColor;
    _bottomView.userInteractionEnabled = YES;
    [self.view addSubview:_bottomView];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(0, 0, KScreenWidth, 50);
    [bottomButton setBackgroundColor:ButtonHColor];
    bottomButton.tag = 31000;
    [bottomButton setTitle:@"确定" forState:UIControlStateNormal];
    bottomButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomButton addTarget:self action:@selector(surePersonInCharge) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:bottomButton];
}

#pragma mark - 获取数据
- (void)getPersonInChargeData
{
    NSMutableArray *homeDta = [NSMutableArray array];
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    
    self.chosePerson ? [homeDta addObjectsFromArray:personData] : [homeDta addObjectsFromArray:areaData];
    for (NSDictionary *dic in homeDta) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:@NO forKey:@"isChoose"];
        [_PersonInChargeData addObject:mutDic];
    }
    
    [_HomePersonInChargeChooseTableView reloadData];
}

#pragma mark - 按钮事件
/**
 确定
 */
- (void)surePersonInCharge
{
    NSMutableArray *datas = [NSMutableArray array];
    for (NSMutableDictionary *person in self.PersonInChargeData) {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if ([[person valueForKey:@"isChoose"] boolValue] == YES) {
            [data setObject:person forKey:@"key"];
            [datas addObject:data];
        }
    }
    SpecificInformationViewController *SpecificInformationVC = [[SpecificInformationViewController alloc] init];
    SpecificInformationVC.paras = [datas mutableCopy];
    [self.navigationController pushViewController:SpecificInformationVC animated:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *person = _PersonInChargeData[indexPath.row];
    person[@"isChoose"] = @(![person[@"isChoose"] boolValue]);
    if (!_isChoose == [BasicControls checkArrayDataWithDataList:_PersonInChargeData]) {
        [self bottomViewAnimationWithShow:[BasicControls checkArrayDataWithDataList:_PersonInChargeData]];
    }
    [tableView reloadData];
    _isChoose = [BasicControls checkArrayDataWithDataList:_PersonInChargeData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _PersonInChargeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personInChargeIndent"];
    if (cell == nil) {
        cell = [[PersonInChargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personInChargeIndent"];
    }
    cell.dic = _PersonInChargeData[indexPath.row];
    return cell;
}

#pragma mark - util
+ (BOOL)checkArrayDataWithDataList:(NSMutableArray *)dataList
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dataList) {
        [array addObject:[dic valueForKey:@"isChoose"]];
    }
    if ([array containsObject:@YES]) {
        return YES;
    }
    return NO;
}

#pragma mark - 动画
- (void)bottomViewAnimationWithShow:(BOOL)show
{
    if (show) {
        [UIView animateWithDuration:.3 animations:^{
            _bottomView.top -= 50;
        }];
        _HomePersonInChargeChooseTableView.height = KScreenHeight - 64 - 50;
    } else {
        _HomePersonInChargeChooseTableView.height = KScreenHeight - 64;
        [UIView animateWithDuration:.3 animations:^{
            _bottomView.top += 50;
        }];
        
    }
}

@end
