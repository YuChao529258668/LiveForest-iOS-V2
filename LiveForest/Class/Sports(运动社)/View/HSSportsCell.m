//
//  HSSportsCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/2.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSSportsCell.h"
#import "UIImageView+WebCache.h"
#import "HSRecommendShareModel.h"
#import "HSChallengeAttendModel.h"

@implementation HSSportsCell

- (void)awakeFromNib {
//    _addressLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.width / 2;
    _avatarImageView.clipsToBounds = YES;
    
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_moreContentsBtn addTarget:self action:@selector(moreContentsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_kanHaoBtn addTarget:self action:@selector(kanHaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_buKanHaoBtn addTarget:self action:@selector(buKanHaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_card"]];
    self.separatorInset = UIEdgeInsetsMake(0, 600, 0, 0);
}

#pragma mark - Actions
- (void)kanHaoBtnClick {
    _onlookStateLabel.text = @"已看好";
    _onlookStateLabel.hidden = NO;
    _kanHaoBtn.hidden = YES;
    _buKanHaoBtn.hidden = YES;
    if (_kanHaoBtnClickBlock) {
        _kanHaoBtnClickBlock();
    }
}

- (void)buKanHaoBtnClick {
    _onlookStateLabel.text = @"不看好";
    _onlookStateLabel.hidden = NO;
    _kanHaoBtn.hidden = YES;
    _buKanHaoBtn.hidden = YES;
    if (_buKanHaoBtnClickBlock) {
        _buKanHaoBtnClickBlock();
    }
}

- (void)likeBtnClick:(UIButton *)btn {
    int likeCount = _likesLabel.text.intValue;
    if (_likeBtn.isSelected) {
        likeCount --;
    } else {
        likeCount ++;
    }
    _likeBtn.selected = !_likeBtn.isSelected;
    _likesLabel.text = [NSString stringWithFormat:@"%d",likeCount];
    
    _recommendShareModel.hasLiked = _likeBtn.isSelected;
    _recommendShareModel.likesCount = _likesLabel.text;
    
    if (_postShareLikeBlock) {
        _postShareLikeBlock(_recommendShareModel.share_id);
    }
}

- (void)moreContentsBtnClick:(UIButton *)btn {
    if (_moreContentsBtnClickBlock) {
        _moreContentsBtnClickBlock();
    }
}

- (void)completeBtnClick:(UIButton *)btn {
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    if (_completeChallengeBtnClickBlock) {
        _completeChallengeBtnClickBlock();
    }
}

#pragma mark - Set
- (void)setRecommendShareModel:(HSRecommendShareModel *)recommendShareModel {
    _recommendShareModel = recommendShareModel;
    
    UIImage *placeholder = [UIImage imageNamed:@"user_default_avatar"];
    
    [self.avatarImageView sd_setImageWithURL:recommendShareModel.avatarPath placeholderImage:placeholder];
    
    self.timeLabel.text = recommendShareModel.createTime;
    
    self.nameLabel.text = recommendShareModel.user_nickname;
    
    placeholder = [UIImage imageNamed:@"default_image"];
    [self.contentImageView sd_setImageWithURL:recommendShareModel.firstContentImagePath placeholderImage:placeholder];
    
//    self.addressLabel.text = [NSString stringWithFormat:@"          %@", recommendShareModel.share_location];
    self.addressLabel.text = recommendShareModel.share_location;
//    HSLog(@"%@",self.addressLabel.text);
//    HSLog(@"%@",recommendShareModel.share_location);

    self.likesLabel.text = recommendShareModel.likesCount;
    
    self.commentsLabel.text = recommendShareModel.comment_count;
    
    self.activityLabel.text = recommendShareModel.activityName;
    
//    HSLog(@"%d",recommendShareModel.hasLiked);
    self.likeBtn.selected = recommendShareModel.hasLiked;
    
    
    if (recommendShareModel.share_in_challenge_nums == nil) {
        recommendShareModel.share_in_challenge_nums = @0;
    }
    [self.moreContentsBtn setTitle:[NSString stringWithFormat:@"查看其它 %@ 条挑战相关内容", recommendShareModel.share_in_challenge_nums] forState:UIControlStateNormal];
}

- (void)setChallengeAttendModel:(HSChallengeAttendModel *)challengeAttendModel {
    _challengeAttendModel = challengeAttendModel;
    
    self.recommendShareModel = challengeAttendModel.share;
    
    if (challengeAttendModel.challenge_attend_state == 1) {
        _completeBtn.selected = NO;
    } else if (challengeAttendModel.challenge_attend_state == 2) {
        _completeBtn.selected = YES;
    }
}

- (void)setSportsCellStyle:(HSSportsCellStyle)sportsCellStyle {
    _sportsCellStyle = sportsCellStyle;
    
    switch (sportsCellStyle) {
        case HSSportsCellStylePlayer:
            _timeLabel.hidden = YES;
            _completeBtn.hidden = YES;
            _kanHaoBtn.hidden = NO;
            _buKanHaoBtn.hidden = NO;
            _onlookStateLabel.hidden = YES;
            break;
        case HSSportsCellStyleCreator:
            _timeLabel.hidden = YES;
            _completeBtn.hidden = NO;
            _kanHaoBtn.hidden = YES;
            _buKanHaoBtn.hidden = YES;
            _onlookStateLabel.hidden = YES;
            break;
        case HSSportsCellStyleOnlooker:
            _timeLabel.hidden = YES;
            _completeBtn.hidden = YES;
            _kanHaoBtn.hidden = NO;
            _buKanHaoBtn.hidden = NO;
            _onlookStateLabel.hidden = YES;
            break;
        case HSSportsCellStyleNone:
            _timeLabel.hidden = NO;
            _completeBtn.hidden = YES;
            _kanHaoBtn.hidden = YES;
            _buKanHaoBtn.hidden = YES;
            _onlookStateLabel.hidden = YES;
            break;
    }
}

@end
