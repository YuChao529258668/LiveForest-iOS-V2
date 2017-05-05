//
//  HSPersonalHomePageController.h
//  LiveForest
//
//  Created by 余超 on 16/1/5.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSUserModel;

@interface HSPersonalHomePageController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

/// default is YES，返回按钮
@property (nonatomic) BOOL shouldHideBackBtn;

/// default is YES ，关注按钮
@property (nonatomic) BOOL shouldHideAttentionBtn;

/// default is NO ，个人详情按钮
@property (nonatomic) BOOL shouldHidePersonDetailBtn;

// 用户ID
@property (nonatomic, copy) NSString *userID;

/// 用户模型
@property (nonatomic, strong) HSUserModel *user;

@end
