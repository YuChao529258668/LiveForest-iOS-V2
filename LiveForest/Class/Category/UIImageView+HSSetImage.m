//
//  UIimage+HSSetImage.m
//  LiveForest
//
//  Created by 余超 on 16/3/30.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "UIImageView+HSSetImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (HSSetImage)

#pragma mark - Private

- (UIImage *)hs_defaultAvatar {
    UIImage *image = [UIImage imageNamed:@"user_default_avatar"];
    if (image == nil) {
        HSLog(@"%s, %@", __func__, @"user_default_avatar不存在");
    }
    return image;
}

- (UIImage *)hs_defaultImage {
    UIImage *image = [UIImage imageNamed:@"default_image"];
    if (image == nil) {
        HSLog(@"%s, %@", __func__, @"default_image不存在");
    }
    return image;
}


- (NSURL *)hs_urlWithString:(NSString *)str {
    NSURL *url = [NSURL URLWithString:str];
    if (!url) {
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:str];
    }
    return url;
}

#pragma mark - Public

- (void)hs_setAvatarWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:[self hs_defaultAvatar]];
}

- (void)hs_setAvatarWithURLStr:(NSString *)urlStr {
    NSURL *url = [self hs_urlWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:[self hs_defaultAvatar]];
}

- (void)hs_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:[self hs_defaultImage]];
}

- (void)hs_setImageWithURLStr:(NSString *)urlStr {
    NSURL *url = [self hs_urlWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:[self hs_defaultImage]];
}

// 裁剪圆角
- (void)hs_clipsToRound {
    self.layer.cornerRadius = self.width /2;
    self.clipsToBounds = YES;
}

@end
