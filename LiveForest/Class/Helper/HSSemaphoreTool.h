//
//  HSSemaphoreTool.h
//  LiveForest
//
//  Created by 余超 on 16/3/27.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSemaphoreTool : NSObject
@property (nonatomic, copy) void (^notifyOnMainThread)();
@property (nonatomic, copy) void (^willNotifyOnMainThread)();
- (void)signal;
- (void)wait;
@end
