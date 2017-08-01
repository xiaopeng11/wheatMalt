//
//  AreaChooseViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AreaChooseViewController.h"
#import "AreaPicker.h"

@interface AreaChooseViewController ()
{
    UITextField *_AreaChooseTF;
}
@end

@implementation AreaChooseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AreaChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"地区选择"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithName:@"确定" target:self action:@selector(sureArea)];
    
    _AreaChooseTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 45)];
    _AreaChooseTF.backgroundColor = [UIColor whiteColor];
    _AreaChooseTF.font = LargeFont;
    _AreaChooseTF.placeholder = @"选择地区";
    _AreaChooseTF.textAlignment = NSTextAlignmentCenter;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *largeAreas = [userdefaults objectForKey:wheatMalt_LargeAreaData];
    _AreaChooseTF.text = largeAreas[0];
    [self.view addSubview:_AreaChooseTF];
    
    AreaPicker *areaPicker = [[AreaPicker alloc] initWithFrame:CGRectMake(0, 65, KScreenWidth, 200)];
    areaPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:areaPicker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areachange:) name:@"AreaChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)areachange:(NSNotification *)noti
{
    _AreaChooseTF.text = noti.object;
}

- (void)sureArea
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:_AreaChooseTF.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
