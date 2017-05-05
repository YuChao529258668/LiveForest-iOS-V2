//
//  HSUserTool.h
//  LiveForest
//
//  Created by 余超 on 16/3/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUserTool : NSObject

//+ (UIImage *)userAvatar;

/// 会调用SDWebImage的sd_setImageWithURL: placeholderImage:方法
+ (void)setUserAvatar:(UIImageView *)iv;

/// 会调用SDWebImage的sd_setImageWithURL: placeholderImage:方法
+ (void)setUserAvatarWithURLString:(NSString *)urlStr imageView:(UIImageView *)iv;

@end
