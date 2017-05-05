//
//  HSShopThemeContentCell.m
//  LiveForest
//
//  Created by 余超 on 15/12/31.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShopThemeContentCell.h"
#import "HSGoods.h"
#import "UIImageView+WebCache.h"

@implementation HSShopThemeContentCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//    [self addStrikethroughTo:_falsePriceLabel];
//}

// 添加中划线
- (void)addStrikethroughTo:(UILabel *)label {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(NSUnderlineStyleSingle), NSStrikethroughStyleAttributeName, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], NSStrikethroughColorAttributeName, nil];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:label.text attributes:attributes];
    label.attributedText = as;

}

- (void)setGoods:(HSGoods *)goods {
    _goods = goods;

    UIImage *pl = [UIImage imageNamed:@"default_image"];
    [_goodsImageView sd_setImageWithURL:goods.goodsImageURLs.firstObject placeholderImage:pl];
    _nameLabel.text = goods.goods_name;
    _introductionLabel.text = goods.goods_brief;
    _priceLabel.text = [NSString stringWithFormat:@"￥ %@", goods.goods_market_price];
    _falsePriceLabel.text = [NSString stringWithFormat:@"￥ %@", goods.goods_shop_price];
    [self addStrikethroughTo:_falsePriceLabel];
    _falsePriceLabel.hidden = YES;// 加中划线无效，可能是模拟器的问题，先隐藏
}

@end
