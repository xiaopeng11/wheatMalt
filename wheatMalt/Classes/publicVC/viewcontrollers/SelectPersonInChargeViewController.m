//
//  SelectPersonInChargeViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SelectPersonInChargeViewController.h"
#import "SelectPersonInChargeTableViewCell.h"
@interface SelectPersonInChargeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_SelectPersonInChargeTableView;
    NSMutableArray *_SelectPersonInChargeDataList;
    
    NSMutableDictionary *_choseDic;
}
@end

@implementation SelectPersonInChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self drawSelectPersonInChargeUI];
    
    [self getSelectPersonInCharge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择负责人
- (void)selectPersonInCharge
{
    NSMutableDictionary *lastDic = [NSMutableDictionary dictionary];
    if (self.changePersnInCharge) {
        if ([[_choseDic valueForKey:@"select"] isEqualToString:@"0"]) {
            if ([self.key isEqualToString:@"name"]) {
                [lastDic setValue:@(0) forKey:@"id"];
            } else {
                [lastDic setValue:@"" forKey:self.key];
            }
        }
        self.changePersnInCharge(_choseDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 绘制UI
- (void)drawSelectPersonInChargeUI
{
    if ([self.key isEqualToString:@"name"]) {
        [self NavTitleWithText:@"选择负责人"];
    } else if ([self.key isEqualToString:@"warningTime"]) {
        [self NavTitleWithText:@"选择下次提醒时间"];
    }
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"确定" target:self action:@selector(selectPersonInCharge)];
    
    _SelectPersonInChargeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _SelectPersonInChargeTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
    if ([self.key isEqualToString:@"warningTime"]) {
        _SelectPersonInChargeTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 50);
    } else {
        _SelectPersonInChargeTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
    }
    _SelectPersonInChargeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _SelectPersonInChargeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _SelectPersonInChargeTableView.backgroundColor = BaseBgColor;
    _SelectPersonInChargeTableView.delegate = self;
    _SelectPersonInChargeTableView.dataSource = self;
    _SelectPersonInChargeTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_SelectPersonInChargeTableView];
    
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 50, KScreenWidth, 50)];
    warningLabel.numberOfLines = 0;
    warningLabel.backgroundColor = [UIColor whiteColor];
    warningLabel.text = @"客户状态未发生改变,系统会在指定时间发送通知给您(重复提醒时间为上一次提醒时间的两倍)";
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.font = [UIFont systemFontOfSize:13];
    warningLabel.textColor = [UIColor grayColor];
    if ([self.key isEqualToString:@"warningTime"]) {
        warningLabel.hidden = NO;
    } else {
        warningLabel.hidden = YES;
    }
    [self.view addSubview:warningLabel];
}
#pragma mark - 获取数据
- (void)getSelectPersonInCharge
{
    _SelectPersonInChargeDataList = [NSMutableArray array];
    for (NSDictionary *dic in self.datalist) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([self.key isEqualToString:@"name"]) {
            if ([[mutDic valueForKey:@"id"] intValue] == [[self.personInCharge valueForKey:@"id"] intValue]) {
                [mutDic setObject:@"1" forKey:@"select"];
                _choseDic = [mutDic mutableCopy];
            } else {
                [mutDic setObject:@"0" forKey:@"select"];
            }
        } else {
            if ([[mutDic valueForKey:self.key] isEqualToString:[self.personInCharge valueForKey:self.key]]) {
                [mutDic setObject:@"1" forKey:@"select"];
                _choseDic = [mutDic mutableCopy];
            } else {
                [mutDic setObject:@"0" forKey:@"select"];
            }
        }
        
        [_SelectPersonInChargeDataList addObject:mutDic];
    }
    [_SelectPersonInChargeTableView reloadData];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *mutDic = _SelectPersonInChargeDataList[indexPath.row];
    if (self.canConsloe) {
        if ([mutDic isEqual:_choseDic]) {
            if ([[mutDic valueForKey:@"select"] isEqualToString:@"0"]) {
                [mutDic setObject:@"1" forKey:@"select"];
            } else {
                [mutDic setObject:@"0" forKey:@"select"];
            }
        } else {
            [mutDic setObject:@"1" forKey:@"select"];
            for (NSMutableDictionary *dic in _SelectPersonInChargeDataList) {
                if ([dic isEqual:_choseDic]) {
                    [dic setObject:@"0" forKey:@"select"];
                }
            }
        }
    } else {
        if ([mutDic isEqual:_choseDic]) {
            [mutDic setObject:@"1" forKey:@"select"];
        } else {
            [mutDic setObject:@"1" forKey:@"select"];
            for (NSMutableDictionary *dic in _SelectPersonInChargeDataList) {
                if ([dic isEqual:_choseDic]) {
                    [dic setObject:@"0" forKey:@"select"];
                }
            }
        }
    }

    _choseDic = mutDic;

    [tableView reloadData];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _SelectPersonInChargeDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SelectPersonInChargeindet = @"SelectPersonInChargeindet";
    SelectPersonInChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectPersonInChargeindet];
    if (cell == nil) {
        cell = [[SelectPersonInChargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectPersonInChargeindet];
    }
    cell.dic = _SelectPersonInChargeDataList[indexPath.row];
    cell.key = self.key;
    return cell;
}
@end
