//
//  HSCloseKeyboardGesture.m
//  LiveForest
//
//  Created by 余超 on 16/1/7.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSCloseKeyboardGesture.h"

@implementation HSCloseKeyboardGesture

+ (instancetype)gesture {
    HSCloseKeyboardGesture *g = [[HSCloseKeyboardGesture alloc]init];
    [g addTarget:g action:@selector(closeKeyboard)];
    return g;
}

- (void)closeKeyboard {
    [self.view endEditing:YES];
}

@end
