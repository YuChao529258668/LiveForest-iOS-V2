//
//  HSNavigationTool.h
//  LiveForest
//
//  Created by 余超 on 16/3/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSChallengeDetailController.h"

/**
 *  负责界面跳转
 */
@interface HSNavigationTool : NSObject

/// 导航到分享详情界面，使用fromVC的导航控制器push
+ (void)pushShareDetailViewControllerWithResourceID:(NSString *)resourceID From:(UIViewController *)fromVC;

/// 导航到挑战详情界面，使用fromVC的导航控制器push
//+ (void)pushChallengeDetailViewControllerWithResourceID:(NSString *)resourceID From:(UIViewController *)fromVC;

/// 导航到挑战详情界面，使用fromVC的导航控制器push
+ (void)pushChallengeDetailViewControllerWithResource:(id)resource style:(HSChallengeUserStyle)style from:(UIViewController *)fromVC;
//+ (void)pushChallengeDetailViewControllerWithResource:(id)resource From:(UIViewController *)fromVC;


@end
