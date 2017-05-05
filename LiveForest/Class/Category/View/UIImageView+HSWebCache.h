//
//  UIImageView+HSWebCache.h
//  LiveForest
//
//  Created by 余超 on 15/12/2.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HSWebCache)

- (void)hs_setImageWithURLString:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;

@end
