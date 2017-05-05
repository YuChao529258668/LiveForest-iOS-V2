//
//  HSCreateShareController.h
//  LiveForest
//
//  Created by 余超 on 15/12/29.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCCycleScrollView;
@class HSAddPhotoView;
@class YCTextView;

@interface HSCreateShareController : UIViewController

// 顶部
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

// 上
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 中
@property (weak, nonatomic) IBOutlet YCTextView *contentTextView;
@property (weak, nonatomic) IBOutlet HSAddPhotoView *addPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet YCCycleScrollView *challengeView;

// 下
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
@property (weak, nonatomic) IBOutlet UIButton *sportBtn;

@end
