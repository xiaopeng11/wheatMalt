//
//  CropViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CropViewController.h"
#import "WriteCropViewController.h"
@interface CropViewController ()

@end

@implementation CropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    [self NavTitleWithText:@"吐槽"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"writeCrop" highImageName:@"writeCrop" target:self action:@selector(writeCrop)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件
/**
 麦讯
 */
- (void)writeCrop
{
    WriteCropViewController *WriteCropVC = [[WriteCropViewController alloc] init];
    [self.navigationController pushViewController:WriteCropVC animated:YES];
}

@end
