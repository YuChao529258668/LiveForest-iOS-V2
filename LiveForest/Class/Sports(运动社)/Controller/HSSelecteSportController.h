//
//  HSSelecteSportController.h
//  LiveForest
//
//  Created by 余超 on 16/2/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSSportModel;

@interface HSSelecteSportController : UIViewController
@property (nonatomic, copy) void (^completeBlock) (HSSportModel *sport) ;
@property (strong, nonatomic) HSSportModel *selectedSport;
@end
