//
//  ImportCropsViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ImportCropsViewController.h"

@interface ImportCropsViewController ()

@end

@implementation ImportCropsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"重大事项"];
    
    NoDataView *noCollectionCropView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) type:PlaceholderViewTypeNoFunction delegate:nil];
    [self.view addSubview:noCollectionCropView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
