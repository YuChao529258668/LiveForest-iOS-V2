//
//  HSShareDetailCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/24.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShareDetailCell.h"
#import "HSRecommendShareModel.h"
#import "UIImageView+WebCache.h"

@implementation HSShareDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
    _avatarImageView.clipsToBounds = YES;
    
    [_likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)likeBtnClick {
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

- (void)setRecommendShareModel:(HSRecommendShareModel *)recommendShareModel {
    _recommendShareModel = recommendShareModel;
    
    UIImage *placeholder = [UIImage imageNamed:@"user_default_avatar"];
    
    [self.avatarImageView sd_setImageWithURL:recommendShareModel.avatarPath placeholderImage:placeholder];
    
    self.timeLabel.text = recommendShareModel.createTime;
    self.contentLabel.text = recommendShareModel.share_description;
    self.nameLabel.text = recommendShareModel.user_nickname;
    
    placeholder = [UIImage imageNamed:@"default_image"];
    [self.contentImageView sd_setImageWithURL:recommendShareModel.firstContentImagePath placeholderImage:placeholder];
    
    self.addressLabel.text = recommendShareModel.share_location;
    //    HSLog(@"%@",self.addressLabel.text);
    //    HSLog(@"%@",recommendShareModel.share_location);
    
    self.likesLabel.text = recommendShareModel.likesCount;
    
    self.commentsLabel.text = recommendShareModel.comment_count;
    
    self.activityLabel.text = recommendShareModel.activityName;
    self.likeBtn.selected = recommendShareModel.hasLiked;
    //    HSLog(@"%d",recommendShareModel.hasLiked);
}

@end
