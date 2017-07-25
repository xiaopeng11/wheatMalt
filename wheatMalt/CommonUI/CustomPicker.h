//
//  CustomPicker.h
//  wheatMalt
//
//  Created by Apple on 2017/7/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPicker : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,retain)NSDate *date;

@end
