//
//  HSYueBanTableViewCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/3.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSYueBanTableViewCell.h"
#import "HSYueBanModel.h"
#import "HSChallengeModel.h"
#import "HSUserModel.h"
#import "UIImageView+WebCache.h"

@implementation HSYueBanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.width / 2;
    _avatarImageView.clipsToBounds = YES;
    
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setYueBanModel:(HSYueBanModel *)yueBanModel {
//    
//    _yueBanModel = yueBanModel;
//
//    UIImage *placeholder = [UIImage imageNamed:@"sportsCell"];
//    
//    [self.avatarImageView sd_setImageWithURL:yueBanModel.avatarPath placeholderImage:placeholder];
//    
//    self.timeLabel.text = yueBanModel.createTime;
//    
//    self.nameLabel.text = yueBanModel.user_nickname;
//    
//    
//    self.sportLabel.text = yueBanModel.activityName;
//
//}

- (void)setChallengeModel:(HSChallengeModel *)challengeModel {
    _challengeModel = challengeModel;
    
    _sourceLabel.text = @"挑战";
//    _countBtn.hidden = YES;
    [_countBtn setTitle:[NSString stringWithFormat:@"%ld", challengeModel.challenge_user_id_invited.count ] forState:UIControlStateNormal];
    NSURL *url = [NSURL hs_URLWithString:_challengeModel.user_creator.user_logo_img_path];
    [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_default_avatar"]];
    _nameLabel.text = challengeModel.user_creator.user_nickname;
    _promptLabel.text = @"向你挑战";
    _sportLabel.text = challengeModel.challenge_content;
    _contentLabel.text = challengeModel.challenge_text_info;
    _rewardLabel.text = challengeModel.challenge_reward_text;
    _timeLabel.text = [NSString stringWithFormat:@"%@ 前有效", challengeModel.deadlineDateString];
//    _timeLabel.text = [self calculateTime:challengeModel.challenge_deadline];
}

//- (NSString *)calculateTime:(NSNumber *)deadline {
//    NSString *timeStr;
//    long seconds = (long)(deadline.doubleValue - [NSDate date].timeIntervalSince1970);
//    int h = (int) seconds / 3600;
//    int m =  (seconds % 3600 / 60.0);
//    int s = seconds % 3600 % 60;
//}

- (void)refuseBtnClick {
    if (_refuseBtnClickBlock) {
        _refuseBtnClickBlock(self);
    }
}

- (void)agreeBtnClick {
    if (_agreeBtnClickBlock) {
        _agreeBtnClickBlock(self);
    }
}

@end
