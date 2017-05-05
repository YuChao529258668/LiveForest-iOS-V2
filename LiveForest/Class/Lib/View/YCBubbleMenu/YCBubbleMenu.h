//
//  YCBubbleMenu.h
//
//  Created by 余超 on 15/12/13.
//  Copyright © 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  YCBubbleMenuDelegate;

@interface YCBubbleMenu : UIView

@property (nonatomic, weak) id<YCBubbleMenuDelegate> delegate;

+ (instancetype)menuWithFrame:(CGRect)frame radius:(float)r normalImage:(UIImage *)normal selectedImage:(UIImage *)selected delegate:(id<YCBubbleMenuDelegate>)delegate;

//- (void)addButton:(UIButton *)btn withAngle:(float)angle clickBlock:(void(^)())block;
//- (void)addButtonWithImage:(UIImage *)image withAngle:(float)angle clickBlock:(void(^)())block;
- (void)addButtonWithImage:(NSString *)imageName withAngle:(float)angle clickBlock:(void(^)())block;
- (void)addButtonWithTitlte:(NSString *)title Image:(NSString *)imageName withAngle:(float)angle clickBlock:(void(^)())block;
- (void)addButton:(UIButton *)btn withAngle:(float)angle clickBlock:(void(^)())block;

@end


@protocol YCBubbleMenuDelegate <NSObject>

@optional
@required

@end