//
//  HSGoods.m
//  LiveForest
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSGoods.h"

@implementation HSGoods

- (void)setGoods_logo:(NSArray *)goods_logo {
    _goods_logo = goods_logo;
    
    _goodsImageURLs = [NSMutableArray new];
    for (NSString *urlStr in goods_logo) {
        NSURL *url = [NSURL hs_URLWithString:urlStr];
        [_goodsImageURLs addObject:url];
    }
}

/// 用于演示，kind = 0 或 1，两组数据
+ (NSMutableArray *)test:(NSInteger)kind {
    NSString *goodsImg;
    NSString *goodsImg2;
    
    HSGoods *g = [HSGoods new];
    HSGoods *g2= [HSGoods new];

    // 水果
    if (kind == 0) {
        // 草莓
        goodsImg = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494323437&di=94d841bbf25194b03447028afeee269a&imgtype=jpg&er=1&src=http%3A%2F%2Fpic1.nipic.com%2F2008-12-24%2F20081224233839511_2.jpg";
        // 芒果
        goodsImg2 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493728881693&di=6a15f13123f2f6e4b6cf3e618286deb8&imgtype=0&src=http%3A%2F%2Fn1.itc.cn%2Fimg8%2Fwb%2Frecom%2F2016%2F07%2F29%2F146979094092216014.JPEG";
        
        g.goodsImageURLs = @[goodsImg].mutableCopy;
        g.goods_name = @"草莓";
        g.goods_shop_price = @"99";
        g.goods_credit = @" credit";
        g.goods_number = @"5";
        g.goods_market_price = @"199";
        g.goods_brief = @"红色的草莓";
        g.goods_desc = @"新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!新鲜草莓，甜过初恋哦!";
        
        g2.goodsImageURLs = @[goodsImg2].mutableCopy;
        g2.goods_name = @"芒果";
        g2.goods_shop_price = @"99";
        g2.goods_credit = @"33333";
        g2.goods_number = @"5";
        g2.goods_market_price = @"199";
        g2.goods_brief = @"金色的芒果";
        g2.goods_desc = @"新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!新鲜芒果，甜过初恋哦!";

    } else { // 巧克力
        // 巧克力冰激凌
        goodsImg = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493729024475&di=d3945cc8ead28ae28e37936309dcd479&imgtype=0&src=http%3A%2F%2Fwww.1dangao.com%2Fimages%2F20140627%2F4aa44e6dec1ebbb6.jpg";
        // 巧克力蛋糕
        goodsImg2 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493729125038&di=e21af0eba21d3e5afaee8b9aff2fac96&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201308%2F11%2F20130811100002_QyKjU.jpeg";

        g.goodsImageURLs = @[goodsImg].mutableCopy;
        g.goods_name = @"巧克力冰激凌";
        g.goods_shop_price = @"99";
        g.goods_credit = @"";
        g.goods_number = @"5";
        g.goods_market_price = @"199";
        g.goods_brief = @"巧克力冰激凌";
        g.goods_desc = @"好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃";
        
        g2.goodsImageURLs = @[goodsImg2].mutableCopy;
        g2.goods_name = @"巧克力蛋糕";
        g2.goods_shop_price = @"99";
        g2.goods_credit = @"";
        g2.goods_number = @"5";
        g2.goods_market_price = @"199";
        g2.goods_brief = @"巧克力蛋糕";
        g2.goods_desc = @"好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃好吃";
    }
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:g];
    [array addObject:g2];
    
    return array;
}

@end
