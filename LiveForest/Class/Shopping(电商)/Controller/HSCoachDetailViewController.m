//
//  HSCoachDetailViewController.m
//  LiveForest
//
//  Created by 余超 on 16/8/8.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSCoachDetailViewController.h"
#import "HSGoods.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface HSCoachDetailViewController ()

@end

@implementation HSCoachDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_imageView sd_setImageWithURL:_goods.goodsImageURLs.firstObject];
    _nameL.text = _goods.goods_name;
    _priceL.text =  [NSString stringWithFormat:@"￥ %@ /每月", _goods.goods_market_price];
    _briefLabel.text = _goods.goods_brief;
}

- (IBAction)orderBtnClick:(UIButton *)sender {
    [sender setTitle:@"定制成功" forState:UIControlStateNormal];
    sender.userInteractionEnabled = NO;
}


@end
