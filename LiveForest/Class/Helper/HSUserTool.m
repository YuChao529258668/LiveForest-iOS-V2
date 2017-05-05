//
//  HSUserTool.m
//  LiveForest
//
//  Created by 余超 on 16/3/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSUserTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HSUserModel.h"

//static UIImage *userAvatarImage;

@implementation HSUserTool

+ (void)setUserAvatarWithURLString:(NSString *)urlStr imageView:(UIImageView *)iv {
    UIImage *image = [UIImage imageNamed:@"user_default_avatar"];
    
    [iv sd_setImageWithURL:[NSURL hs_URLWithString: urlStr] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

+ (void)setUserAvatar:(UIImageView *)iv {
    [HSUserTool setUserAvatarWithURLString:[HSUserModel currentUser].user_logo_img_path imageView:iv];
}

@end
