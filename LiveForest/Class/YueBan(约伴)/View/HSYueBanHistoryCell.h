//
//  HSYueBanHistoryCell.h
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSChallengeModel;
@class HSYueBanModel;

@interface HSYueBanHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) HSChallengeModel *challenge;
@property (nonatomic, strong) HSYueBanModel *yueBan;

@end
