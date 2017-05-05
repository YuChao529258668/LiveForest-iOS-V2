//
//  HSPersonalHeadCell.h
//  LiveForest
//
//  Created by 余超 on 16/1/5.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPersonalHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *personDetailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (nonatomic) BOOL canLookPersonDetail;
@property (nonatomic, copy) NSString *userID;
@end
