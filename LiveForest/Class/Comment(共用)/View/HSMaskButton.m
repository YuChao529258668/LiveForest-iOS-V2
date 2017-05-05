//
//  HSMaskButton.m
//  LiveForest
//
//  Created by 余超 on 16/1/20.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSMaskButton.h"

@implementation HSMaskButton

+ (instancetype)maskButtonWithBlock:(void(^)())block {
    HSMaskButton *btn = [[HSMaskButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    btn.block = block;
    [btn addTarget:btn action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)click {
    if (_block) {
        _block();
        _block = nil;
    }
    
    [self removeFromSuperview];
}

- (void)addToWindow {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

//- (void)dealloc {
//    HSLog(@"maskButton 释放了");
//}
@end
