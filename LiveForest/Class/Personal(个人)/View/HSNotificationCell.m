//
//  HSNotificationCell.m
//  LiveForest
//
//  Created by 余超 on 16/3/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSNotificationCell.h"
#import "HSPersonalNotification.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HSNotificationCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setNotification:(HSPersonalNotification *)notification {
    _notification = notification;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL hs_URLWithString:_notification.notification_user_logo] placeholderImage:self.avatarImageView.image];
//    self.titleLabel.text = _notification.notification_title;
    self.titleLabel.text = _notification.notification_content;
}

@end
