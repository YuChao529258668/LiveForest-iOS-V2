//
//  UIImageView+HSWebCache.m
//  LiveForest
//
//  Created by 余超 on 15/12/2.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "UIImageView+HSWebCache.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (HSWebCache)

- (void)hs_setImageWithURLString:(NSString *)urlStr placeholderImage:(UIImage *)placeholder {
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (!url) {
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlStr];
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

@end
