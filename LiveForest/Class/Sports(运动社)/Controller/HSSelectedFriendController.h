//
//  HSSelectedFriendController.h
//  LiveForest
//
//  Created by 余超 on 16/2/18.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSelectedFriendController : UIViewController
@property (nonatomic, copy) void (^completeBlock) (NSArray *friends) ;
@property (strong, nonatomic) NSMutableArray *selectedFriends;

+ (instancetype)selectedFriendController;

@end
