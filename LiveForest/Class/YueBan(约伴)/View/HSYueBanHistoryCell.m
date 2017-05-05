//
//  HSYueBanHistoryCell.m
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSYueBanHistoryCell.h"
#import "HSChallengeModel.h"
#import "HSYueBanModel.h"
#import "HSUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HSYueBanHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.width/2;
    _avatarImageView.clipsToBounds = YES;
}

- (void)setChallenge:(HSChallengeModel *)challenge {
    if (challenge.user_creator == nil) {
        challenge.user_creator = [HSUserModel currentUser];
    }

    _challenge = challenge;
    
    [_avatarImageView sd_setImageWithURL:[NSURL hs_URLWithString:challenge.user_creator.user_logo_img_path] placeholderImage:_avatarImageView.image];

    NSString *userName = challenge.user_creator.user_nickname;
//    NSString *str = challenge.challenge_state.intValue? @"未完成": @"已完成";
//    _titleLabel.text = [NSString stringWithFormat:@"%@ %@ 挑战",userName, str];
    _titleLabel.text = [NSString stringWithFormat:@"%@ 发起的挑战",userName];
    _contentLabel.text = challenge.challenge_text_info;
}

- (void)setYueBan:(HSYueBanModel *)yueBan {
    _yueBan = yueBan;
    
    [_avatarImageView sd_setImageWithURL:[NSURL hs_URLWithString:yueBan.user_logo_img_path] placeholderImage:_avatarImageView.image];
    NSString *userName = yueBan.user_nickname;
    if (userName == nil) {
        userName = [HSUserModel currentUser].user_nickname;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@ 发起的约伴",userName];
    _contentLabel.text = yueBan.yueban_text_info;

}

@end
