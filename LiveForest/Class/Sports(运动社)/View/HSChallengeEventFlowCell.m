//
//  HSChallengeEventFlowCell.m
//  LiveForest
//
//  Created by 余超 on 16/3/29.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSChallengeEventFlowCell.h"
#import "HSRecommendShareModel.h"
#import "UIImageView+HSSetImage.h"
#import "HSDataFormatHandle.h"

@implementation HSChallengeEventFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HSRecommendShareModel *)model {
    _model = model;
    
    self.contentLabel.text = model.share_description;
    [self.contentImageView hs_setImageWithURL:model.firstContentImagePath];
//    self.timeLabel.text = model.createTime;
    self.timeLabel.text = [HSDataFormatHandle dayStringWithDateFormat:@"M/d" interval:model.share_create_time.doubleValue];
}

@end
