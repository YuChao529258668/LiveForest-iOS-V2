//
//  HSAddPhotoView.h
//  LiveForest
//
//  Created by 余超 on 16/1/7.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAddPhotoView : UIView

/// 放背景图片。当设置image属性时，backgroundView会被设置为nil。
@property (nonatomic, strong) UIImageView *backgroundView;

- (void)setImage:(UIImage *)image;
- (UIImage *)image;
- (void)setbackgroundImage:(UIImage *)image;

///拍照：photo+(long)[NSDate date].timeIntervalSince1970；从相册选取：相片在相册中的id，包含在UIImagePickerControllerReferenceURL。
@property (nonatomic, copy) NSString *imageID;

@end
