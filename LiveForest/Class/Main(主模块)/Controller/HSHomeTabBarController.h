//
//  HSHomeTabBarController.h
//  LiveForest
//
//  Created by 余超 on 15/11/25.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSHomeTabBarController : UITabBarController

// 这些方法是环信聊天demo里面的
- (void)setupUnreadMessageCount;
- (void)setupUntreatedApplyCount;
- (void)networkChanged:(EMConnectionState)connectionState;
- (void)playSoundAndVibration;
- (void)showNotificationWithMessage:(EMMessage *)message;


@end
