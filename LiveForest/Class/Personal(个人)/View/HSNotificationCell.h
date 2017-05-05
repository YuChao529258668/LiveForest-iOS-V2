//
//  HSNotificationCell.h
//  LiveForest
//
//  Created by 余超 on 16/3/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSPersonalNotification;

@interface HSNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) HSPersonalNotification *notification;

@end
