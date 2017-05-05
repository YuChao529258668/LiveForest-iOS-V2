//
//  HSYueBanTableViewCell.h
//  LiveForest
//
//  Created by 余超 on 15/12/3.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSYueBanModel;
@class HSChallengeModel;

@interface HSYueBanTableViewCell : UITableViewCell

@property (nonatomic, strong) HSYueBanModel *yueBanModel;
@property (nonatomic, strong) HSChallengeModel *challengeModel;
@property (nonatomic, strong) void(^agreeBtnClickBlock)(HSYueBanTableViewCell *cell);
@property (nonatomic, strong) void(^refuseBtnClickBlock)(HSYueBanTableViewCell *cell);


@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end
