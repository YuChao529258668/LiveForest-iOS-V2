//
//  HSAddPhotoView.m
//  LiveForest
//
//  Created by 余超 on 16/1/7.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSAddPhotoView.h"

@import Photos;

@interface HSAddPhotoView () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation HSAddPhotoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupImageView:nil];
        [self setupBackgroundView:nil];
        [self setupGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView:nil];
        [self setupBackgroundView:nil];
        [self setupGesture];
    }
    return self;
}

- (void)setupImageView:(UIImage *)image {
    _imageView = [[UIImageView alloc]initWithImage:image];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    [self addSubview:_imageView];
}

- (void)setupBackgroundView:(UIImage *)image {
    if (!image) {
        image = [UIImage imageNamed:@"btn_addimage_n"];
    }
    _backgroundView = [[UIImageView alloc]initWithImage:image];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self insertSubview:_backgroundView belowSubview:_imageView];
}

- (void)setupGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setbackgroundImage:(UIImage *)image {
    _backgroundView.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectZero;
    frame.size = self.frame.size;
    _imageView.frame = frame;
    _backgroundView.frame = frame;
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *b = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *c = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:a];
    [alert addAction:b];
    [alert addAction:c];
    
    [[self controller] presentViewController:alert animated:YES completion:nil];
}

- (void)takePhotoWithSourceType:(UIImagePickerControllerSourceType)type {
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        [self showFailure];
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = type;
    picker.allowsEditing = NO;
    [[self controller] presentViewController:picker animated:YES completion:nil];
}

- (void)showFailure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"无法访问相册或者相机" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:a];
    
    [[self controller] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    获取在相册中的位置，如果是拍照，值为nil。
    NSURL *referenceURL =  info[UIImagePickerControllerReferenceURL];
    
//    如果是从相册中选取的照片
    if (referenceURL) {
        NSString *urlStr = [NSString stringWithFormat:@"%@", referenceURL];
        //assets-library://asset/asset.JPG?id=F808FA96-5D6B-4DE0-9A9D-468B1E56943B&ext=JPG
        NSRange r1 = [urlStr rangeOfString:@"id="];
        NSRange r2 = [urlStr rangeOfString:@"&ext="];
        NSRange range = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *imageID = [urlStr substringWithRange:range];
        
        self.imageID = imageID;
    } else {
//        如果是拍照。
        NSString *imageID = [NSString stringWithFormat:@"photo%ld", (long)[NSDate date].timeIntervalSince1970];
        self.imageID = imageID;
    }
    
    _imageView.image = info[UIImagePickerControllerOriginalImage];
    _backgroundView = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //完成后发送通知   by qiang  on 3.14
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HSPhotoPickedNotification" object:nil];
}

- (UIViewController *)controller {
    for (UIResponder *next = self.nextResponder; next; next = next.nextResponder) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
    }
    return nil;
}

// 获取相片名字。在UIImagePickerController的回调函数中调用。
- (NSString *)imageNameWithMediaInfo:(NSDictionary<NSString *,id> *)info {
    //    需要@import Photos;
    
    NSString *referenceURL = [NSString stringWithFormat:@"%@", info[UIImagePickerControllerReferenceURL]];
    //assets-library://asset/asset.JPG?id=F808FA96-5D6B-4DE0-9A9D-468B1E56943B&ext=JPG
    
    NSRange r1 = [referenceURL rangeOfString:@"id="];
    NSRange r2 = [referenceURL rangeOfString:@"&ext="];
    NSRange range = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSString *imageID = [referenceURL substringWithRange:range];

    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[imageID] options:nil];
    PHAsset *asset = fetchResult.lastObject;
    NSString *fileName = [asset valueForKey:@"filename"];
    return fileName;
}

@end
