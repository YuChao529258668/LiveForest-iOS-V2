//
//  HSMaskButton.h
//  LiveForest
//
//  Created by 余超 on 16/1/20.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSMaskButton : UIButton

@property (nonatomic, copy) void (^block)();

+ (instancetype)maskButtonWithBlock:(void(^)())block;
- (void)addToWindow;
@end
