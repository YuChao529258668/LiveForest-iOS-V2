//
//  HSChallengeDetailController.h
//  LiveForest
//
//  Created by 余超 on 15/12/15.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

/// 挑战的创建者、参与者、围观者
typedef  NS_ENUM(NSUInteger, HSChallengeUserStyle) {
    HSChallengeUserStyleNone = 0,
    HSChallengeUserStylePlayer = 1,
    HSChallengeUserStyleCreator = 2,
    HSChallengeUserStyleOnlooker = 3
};

#import <UIKit/UIKit.h>
//@class HSYueBanModel;
@class HSChallengeModel;

@interface HSChallengeDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTV;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UIView *countDownContainView;
@property (weak, nonatomic) IBOutlet UIButton *acceptChallengeBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

//@property (nonatomic, strong) HSYueBanModel *yueBanModel;

/// 赋值会修改challengeID属性
@property (nonatomic, strong) HSChallengeModel *challengeModel;
/// 用来获取后台数据
@property (nonatomic, copy) NSString *challengeID;

@property (nonatomic, assign) HSChallengeUserStyle userStyle;
@end
