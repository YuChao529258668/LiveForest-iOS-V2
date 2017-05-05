//
//  HSShopTheme.m
//  LiveForest
//
//  Created by 余超 on 15/12/7.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShopTheme.h"

@implementation HSShopTheme

- (NSString *)description {
//    return [NSString stringWithFormat:@"goods_theme_title = %@, goods_theme_id = %ld",self.goods_theme_title,(long)self.goods_theme_id];
    return [NSString stringWithFormat:@"goods_theme_title = %@, goods_theme_id = %ld，_goods_theme_logo = %@, goodsThemeLogoURL = %@",self.goods_theme_title,(long)self.goods_theme_id,self.goods_theme_logo, self.goodsThemeLogoURL];
}

- (void)setGoods_theme_logo:(NSString *)goods_theme_logo {
    _goods_theme_logo = goods_theme_logo;
    
    self.goodsThemeLogoURL = [NSURL hs_URLWithString:_goods_theme_logo];
}

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSShopTheme *t = [HSShopTheme new];
    t.goods_theme_logo = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493728627950&di=d7110f477b43dece080d773ad429e559&imgtype=0&src=http%3A%2F%2Fimg02.tooopen.com%2Fimages%2F20151113%2Ftooopen_sy_148516954315.jpg";
    t.goods_theme_title = @"水果";
    t.goods_theme_id = 0;
    t.goods_ids = @[@11, @12];
    t.goods_theme_description = @"新鲜水果，甜过初恋哦";

    HSShopTheme *t2 = [HSShopTheme new];
    t2.goods_theme_logo = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493728969653&di=451c68b163b637a9c4d72ae4f27c55d2&imgtype=0&src=http%3A%2F%2Fimg.wang1314.com%2Fuploadfile%2F2015%2F2015-03-22%2F1427007018632u_473565_uw_800_wh_534_hl_131571_l.jpg";
    t2.goods_theme_title = @"巧克力";
    t2.goods_theme_id = 1;
    t2.goods_ids = @[@21, @22];
    t2.goods_theme_description = @"下雨天和巧克力更配哦";

    [array addObject:t];
    [array addObject:t2];
    
    return array;
}



@end

