//
//  UIimage+HSSetImage.h
//  LiveForest
//
//  Created by 余超 on 16/3/30.
//  Copyright © 2016年 LiveForest. All rights reserved.
//


/// 再次封装 SDWebImage 的方法
@interface UIImageView (HSSetImage)

/// placeholder image为默认用户头像user_default_avatar
- (void)hs_setAvatarWithURL:(NSURL *)url;
/// placeholder image为默认用户头像user_default_avatar
- (void)hs_setAvatarWithURLStr:(NSString *)urlStr;

/// placeholder image为默认图片default_image
- (void)hs_setImageWithURL:(NSURL *)url;
/// placeholder image为默认图片default_image
- (void)hs_setImageWithURLStr:(NSString *)urlStr;

/// 裁剪圆角
- (void)hs_clipsToRound;

@end
