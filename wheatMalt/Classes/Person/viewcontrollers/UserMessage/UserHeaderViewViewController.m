//
//  UserHeaderViewViewController.m
//  wheatMalt
//
//  Created by Apple on 2017/7/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserHeaderViewViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
@interface UserHeaderViewViewController ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,UINavigationControllerDelegate>
{
    UIScrollView *_scrollView;
    
    UIImageView *_headerView;
    
    UIImage *_image;
    
    UIView *_mengbanView;
    
    UIView *_changeHeaderBgView;
}

@end

@implementation UserHeaderViewViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [_headerView removeFromSuperview];
//    [_changeHeaderBgView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NavTitleWithText:@"个人头像"];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"Ellipsis" highImageName:@"Ellipsis" target:self action:@selector(changeHeaderView)];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,((KScreenHeight - 64 - KScreenWidth) / 2), KScreenWidth, KScreenWidth)];
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    [_headerView sd_setImageWithURL:[userMessage valueForKey:@"userpic"] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];

    [_scrollView addSubview:_headerView];
    
    [_scrollView setContentSize:_headerView.image.size];
    
    _mengbanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 210)];
    _mengbanView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    _mengbanView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_mengbanView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenview)];
    [_mengbanView addGestureRecognizer:tap];
    
    _changeHeaderBgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 210)];
    _changeHeaderBgView.backgroundColor = [UIColor grayColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_changeHeaderBgView];
    
    NSArray *titles = @[@"拍照",@"从手机相册选取",@"保存图片",@"取消"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = 52010 + i;
        button.frame = i != titles.count - 1 ? CGRectMake(0, 50 * i, KScreenWidth, 50) : CGRectMake(0, 160, KScreenWidth, 50);
        [button addTarget:self action:@selector(selecttype:) forControlEvents:UIControlEventTouchUpInside];
        [_changeHeaderBgView addSubview:button];
        
        if (i < 2) {
            UIView *lineView = [BasicControls drawLineWithFrame:CGRectMake(0, 49.5 + 50 * i, KScreenWidth, .5)];
            [_changeHeaderBgView addSubview:lineView];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏按钮事件
- (void)changeHeaderView
{
    [UIView animateWithDuration:.3 animations:^{
        _changeHeaderBgView.top = KScreenHeight - 210;
    } completion:^(BOOL finished) {
        _mengbanView.hidden = NO;
    }];
}

#pragma mark - 修改个人信息
- (void)unloadPersonMessageWithHeaderPic:(NSString *)headerPic
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userMessage = [userdefaluts objectForKey:wheatMalt_UserMessage];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:userMessage];
    [params setObject:[userMessage valueForKey:@"id"] forKey:@"id"];
    [params setObject:headerPic forKey:@"filename"];
    
    [HTTPRequestTool requestMothedWithPost:wheatMalt_saveUserPic params:params Token:YES success:^(id responseObject) {
        NSDictionary *newUserMessage = responseObject[@"VO"];
        [userdefaluts setObject:newUserMessage forKey:wheatMalt_UserMessage];
        [userdefaluts synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    } Target:self];
}

#pragma mark - 单机事件
- (void)hiddenview
{
    [UIView animateWithDuration:.3 animations:^{
        _changeHeaderBgView.top = KScreenHeight;
    }];
    _mengbanView.hidden = YES;
}

#pragma mark - 按钮事件
- (void)selecttype:(UIButton *)button
{
    [UIView animateWithDuration:.3 animations:^{
        _changeHeaderBgView.top = KScreenHeight;
    }];
    _mengbanView.hidden = YES;
    if (button.tag == 52010) {
        NSLog(@"拍照");
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    } else if (button.tag == 52011) {
        NSLog(@"相册");
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    } else if (button.tag == 52012) {
        [BasicControls showMessageWithText:@"保存成功" Duration:2];

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:_image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    } else  {
        NSLog(@"取消");
    }
    
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _headerView;
}

//缩放中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.contentSize = CGSizeMake(_image.size.width, _image.size.height * (KScreenHeight / KScreenWidth));
//    _headerView.frame = CGRectMake(0, ((KScreenHeight / KScreenWidth) * _image.size.height) * (((KScreenHeight - KScreenWidth) / KScreenHeight) / 2), _image.size.width, _image.size.height);
}

//缩放结束
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _headerView.image = editedImage;
    //压缩图片大小
//    editedImage = [self imageCompressForWidth:editedImage targetWidth:100];
    //保存在沙河中
    [self saveImage:editedImage withName:@"image.png"];
    //上传图片
    NSString *Path = [ImageFile stringByAppendingPathComponent:@"image.png"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenid = [userDefaults objectForKey:wheatMalt_Tokenid];
    [manager.requestSerializer setValue:tokenid forHTTPHeaderField:@"token"];

    [manager POST:[wheatMalt_upLoadUserPic ChangeInterfaceHeader] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:Path] name:@"image" fileName:@"image.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *fileProp = responseObject[@"fileProp"];
        [self unloadPersonMessageWithHeaderPic:fileProp[@"name"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
    }];

    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < KScreenWidth) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = KScreenWidth;
        btWidth = sourceImage.size.width * (KScreenWidth / sourceImage.size.height);
    } else {
        btWidth = KScreenWidth;
        btHeight = sourceImage.size.height * (KScreenWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
