//
//  HSShareDetailBar.h
//  LiveForest
//
//  Created by 余超 on 15/12/29.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSShareDetailBar;
@protocol HSShareDetailBarDelegate <NSObject>

- (void)HSShareDetailBar:(HSShareDetailBar *)bar backButtonClick:(UIButton *)btn;
- (void)HSShareDetailBar:(HSShareDetailBar *)bar likeButtonClick:(UIButton *)btn;
- (void)HSShareDetailBar:(HSShareDetailBar *)bar commentButtonClick:(UIButton *)btn;
- (void)HSShareDetailBar:(HSShareDetailBar *)bar personButtonClick:(UIButton *)btn;

@end


@interface HSShareDetailBar : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *personBtn;

@property (nonatomic, weak) id<HSShareDetailBarDelegate> delegate;
+ (instancetype)barWithFrame:(CGRect)frame delegate:(id<HSShareDetailBarDelegate>)delegate;

@end
