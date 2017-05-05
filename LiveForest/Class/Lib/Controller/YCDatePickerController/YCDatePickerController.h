//
//  YCDatePickerController.h
//  LiveForest
//
//  Created by 余超 on 16/1/15.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

///  modalPresentationStyle 默认为 UIModalPresentationOverFullScreen，Modal时下面的控制器不会消失。
@interface YCDatePickerController : UIViewController
@property (nonatomic, copy) void (^completeBlock)(NSDate *date);
@property (nonatomic, copy) void (^cancelBlock)();

//+ (instancetype)datePickerControllerWithCompleteBlock:(void (^)(NSDate *date))block;
+ (instancetype)datePickerControllerWithMode:(UIDatePickerMode)mode CompleteBlock:(void (^)(NSDate *date))block;

@end
