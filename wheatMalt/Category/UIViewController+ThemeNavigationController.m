//
//  UIViewController+ThemeNavigationController.m
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UIViewController+ThemeNavigationController.h"


@implementation UIViewController (ThemeNavigationController)
/**
 *  标题
 *
 *  @param text 标题文本
 */
- (void)NavTitleWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 0, 100, 44)];
    title.text = text;
    title.font = LargeFont;
    title.textAlignment = NSTextAlignmentCenter;
    [title sizeToFit];
    title.center = CGPointMake(KScreenWidth / 2.0, 42);
    
    self.navigationItem.titleView = title;
}

- (void)Nav2TitleWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 0, 100, 44)];
    title.text = text;
    title.textColor = [UIColor whiteColor];
    title.font = LargeFont;
    title.textAlignment = NSTextAlignmentCenter;
    [title sizeToFit];
    title.center = CGPointMake(KScreenWidth / 2.0, 42);
    
    self.navigationItem.titleView = title;
}

/**
 *  上传文件
 *
 *  @param uuid uuid
 */
- (void)unloadFileWithUuid:(NSString *)uuid
                  Filepath:(NSString *)filepath
                  FileName:(NSString *)fileName
                     group:(dispatch_group_t)group
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *usemessage = [userdefault objectForKey:wheatMalt_UserMessage];
    NSString *userId = [usemessage valueForKey:@"id"];
    NSString *name = [fileName substringWithRange:NSMakeRange(0, fileName.length - 4)];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uuid forKey:@"uuid"];
    [params setObject:userId forKey:@"userId"];
    if (group != nil) {
        dispatch_group_enter(group);
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[wheatMalt_upLoadUserPic ChangeInterfaceHeader] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:filepath] name:name fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (group != nil) {
            dispatch_group_leave(group);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (group != nil) {
            dispatch_group_leave(group);
        }
    }];
}


/**
 *  图片尺寸压缩
 *
 *  @param sourceImage 图片
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (height / width) * targetWidth;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  保存图片至沙盒
 *
 */
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(currentImage,0.1);
    
    NSLog(@"%lu",(unsigned long)imageData.length);
    // 获取沙盒目录
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取文件夹路径
    NSString *imageDir = ImageFile;
    //判断文件夹是否存在，不存在创建
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:imageDir];
    if (!isExit) {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //指定文件夹下创建文件
    NSString *fullPath = [imageDir stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:YES];
}


/**
 *  清楚图片缓存
 *
 */
- (void)deleteImageFile
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //需要清除的文件路径
    NSString *imageDir = [DOCSFOLDER stringByAppendingPathComponent:@"Image"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:imageDir];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:imageDir error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}

@end
