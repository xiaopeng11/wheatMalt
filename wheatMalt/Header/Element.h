//
//  Element.h
//  wheatMalt
//
//  Created by Apple on 2017/6/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef Element_h
#define Element_h

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define ImageFile [DOCSFOLDER stringByAppendingPathComponent:@"Image"]

#define SYSTEMVERSION     (__bridge NSString *)kCFBundleVersionKey

#define iOS7  ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define isDevice4_4s    (([[UIScreen mainScreen] bounds].size.height) == 480)
//本地缓存
#define wheatMalt_Tokenid @"wheatMalt_Tokenid"           //tokenid
#define wheatMalt_isLoading @"wheatMalt_isLoading"       //登录状态
#define wheatMalt_UserMessage @"wheatMalt_UserMessage"   //用户数据


#define wheatMalt_LargeAreaData @"wheatMalt_LargeAreaData"                 //大区s信息
#define wheatMalt_FirstAreaProvinces @"wheatMalt_FirstAreaProvinces"       //第一个大区的所有省
#define wheatMalt_FirstAreaCitys @"wheatMalt_FirstAreaCitys"               //第一个大区的所有市
#define wheatMalt_FirstAreaTowns @"wheatMalt_FirstAreaTowns"               //第一个大区的所有区


#define wheatMalt_ChargePersonData @"wheatMalt_ChargePersonData" //负责人s信息




//屏宽高
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

//设备长宽比
#define DeviceProportion ((KScreenHeight - 64) / KScreenWidth)

//颜色
#define ColorRGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define COLORA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define TabbarColor [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:0.8]//导航栏颜色
#define BaseBgColor [UIColor colorWithHexString:@"#efefef"]//页面背景色
#define ButtonHColor [UIColor colorWithRed:(56/255.0) green:(173/255.0) blue:(255/255.0) alpha:1.0]//按钮选中颜色
#define ButtonLColor [UIColor colorWithHexString:@"#929292"]//按钮正常颜色

#define commentColor [UIColor colorWithHexString:@"c7c7cd"]  //按钮灰色提示文本（uitextview）

#define GraytextColor [UIColor colorWithHexString:@"#999999"] //项目中的灰色文本
#define RedStateColor [UIColor redColor] //红色文本
#define GreenStateColor [UIColor colorWithHexString:@"#23d923"] //绿色文本
#define WarningStateColor [UIColor colorWithHexString:@"#efb336"] //黄色文本


#define HeaderBgColorArray @[ColorRGB(161, 136, 127),ColorRGB(246, 94, 141),ColorRGB(238, 69, 66),ColorRGB(245, 197, 47),ColorRGB(255, 148, 61),ColorRGB(107, 181, 206),ColorRGB(94, 151, 246),ColorRGB(154, 137, 185),ColorRGB(106, 198, 111),ColorRGB(120, 192, 110)]  //随机数组


//字体
#define LargeFont [UIFont systemFontOfSize:17]  //大号字体
#define SmallFont [UIFont systemFontOfSize:15]  //小号字体





#endif /* Element_h */
