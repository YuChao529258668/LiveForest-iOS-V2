//
//  HSNavigationHistoryMenu.h
//  LiveForest
//
//  Created by 余超 on 16/1/19.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNavigationHistoryMenu : UIView
@property (nonatomic, strong) UIImageView *triangle;

@property (nonatomic, strong) void (^yueBanHistoryBtnClick)();
@property (nonatomic, strong) void (^challengeHistoryBtnClick)();
@end
