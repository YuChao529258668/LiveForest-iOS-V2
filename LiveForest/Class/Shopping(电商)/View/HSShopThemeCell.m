//
//  HSShopThemeCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/7.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShopThemeCell.h"
#import "HSShopTheme.h"
#import "UIImageView+WebCache.h"

@implementation HSShopThemeCell

- (void)setGoodsTheme:(HSShopTheme *)goodsTheme {
    _goodsTheme = goodsTheme;
    
//    UIImage *placeholder = [UIImage imageNamed:@"default_image"];
    UIImage *placeholder = [UIImage imageNamed:@"shoppingCell"];
    
    self.titleLabel.text = goodsTheme.goods_theme_title;
    self.descritionLabel.text = goodsTheme.goods_theme_description;
    [self.contentImageView sd_setImageWithURL:goodsTheme.goodsThemeLogoURL placeholderImage:placeholder];
}

@end
