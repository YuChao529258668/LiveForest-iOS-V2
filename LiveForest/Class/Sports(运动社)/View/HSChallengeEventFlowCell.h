//
//  HSChallengeEventFlowCell.h
//  LiveForest
//
//  Created by 余超 on 16/3/29.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSRecommendShareModel;

@interface HSChallengeEventFlowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (nonatomic, strong) HSRecommendShareModel *model;
@end
