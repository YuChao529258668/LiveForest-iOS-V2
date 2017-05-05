//
//  HSShareDetailCommentCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/24.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShareDetailCommentCell.h"
#import "HSShareCommentModel.h"
#import "UIImageView+WebCache.h"
#import "HSDataFormatHandle.h"
#import "UIImageView+HSSetImage.h"

@implementation HSShareDetailCommentCell

- (void)setModel:(HSShareCommentModel *)model {
    _model = model;
    
//    UIImage *placeholder = [UIImage imageNamed:@"user_default_avatar"];
//    [self.avatarImageView sd_setImageWithURL:model.avatarPath placeholderImage:placeholder];
//    _avatarImageView hs_setAvatarWithURLStr:model.
    _contentLabel.text = model.share_comment_content;
    _nameLabel.text = model.user_nickname;
    _timeLabel.text = [HSDataFormatHandle dateFormaterString:model.share_comment_create_time];
}

@end
