//
//  UIResponder+YCFirstResponder.h
//  LiveForest
//
//  Created by 余超 on 16/1/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (YCFirstResponder)

/**
 *  获取firstResponder
 *
 *  @return UIResponder *
 */
- (UIResponder *)yc_firstResponder;

@end
