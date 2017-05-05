//
//  HSChallengeEventFlowController.h
//  LiveForest
//
//  Created by 余超 on 16/3/29.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSRecommendShareModel;

@interface HSChallengeEventFlowController : UIViewController
//@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) HSRecommendShareModel *shareModel;
+ (instancetype)challengeEventFlowController;

@end
