//
//  HSCoachDetailViewController.h
//  LiveForest
//
//  Created by 余超 on 16/8/8.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSGoods;

@interface HSCoachDetailViewController : UIViewController
@property (nonatomic, strong) HSGoods *goods;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@end
