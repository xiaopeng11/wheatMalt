//
//  UIViewController+ThemeNavigationController.h
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ThemeNavigationController)

- (void)NavTitleWithText:(NSString *)text;
- (void)Nav2TitleWithText:(NSString *)text;

- (void)unloadFileWithUuid:(NSString *)uuid
                  Filepath:(NSString *)filepath
                  FileName:(NSString *)fileName
                     group:(dispatch_group_t)group;
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
- (void)deleteImageFile;
@end
