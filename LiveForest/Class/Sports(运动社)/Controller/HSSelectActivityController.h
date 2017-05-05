//
//  HSSelectActivityController.h
//  LiveForest
//
//  Created by 余超 on 16/2/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSOfficialDisplayPictureActivity;

@interface HSSelectActivityController : UIViewController
@property (nonatomic, copy) void (^completeBlock) (HSOfficialDisplayPictureActivity *selectedActivity) ;
@property (nonatomic, strong) HSOfficialDisplayPictureActivity *selectedActivity;

@end
