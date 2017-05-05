//
//  HSBackButton.m
//  LiveForest
//
//  Created by 余超 on 16/1/12.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSBackButton.h"
#import "UIView+HSController.h"

@implementation HSBackButton

- (void)didMoveToSuperview {
    if (self.superview) {
        [self addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImage *image = [UIImage imageNamed:@"btn_chevronleft_n"];
//        [self setImage:image forState:UIControlStateNormal];
//        self.imageView.contentMode = UIViewContentModeCenter;
//        
//        CGRect frame = self.frame;
//        frame.size = image.size;
//        self.frame = frame;
    }
}

- (void)back {
    UIViewController *controller = [self hs_controller];
    if ([controller presentingViewController]) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    } else {
        [controller.navigationController popViewControllerAnimated:YES];
    }
}

@end
