//
//  HSGoodsDetailController.m
//  LiveForest
//
//  Created by 余超 on 15/12/29.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSGoodsDetailController.h"

#import "HSGoods.h"
#import "HSDataFormatHandle.h"

#import "HSSelectGoodsCountView.h"
#import "SDCycleScrollView.h"

#import "HSHttpRequestTool.h"

@interface HSGoodsDetailController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 上
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

// 中
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *falsePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *carriageLabel; // 运费

// 下
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet HSSelectGoodsCountView *selectGoodsCountView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end


@implementation HSGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    模拟器和真机6正常，真机6p无效。。。
//    self.navigationController.navigationBar.hidden = YES;
    
    [self configSubviews];
    [self setupCycleScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupCycleScrollView {
    _cycleScrollView.imageURLStringsGroup = self.goods.goodsImageURLs;
    NSMutableArray *titles = [NSMutableArray new];
    for (int i = 0; i < self.goods.goods_logo.count; i++) {
        [titles addObject:@" "];
    }
    _cycleScrollView.titlesGroup = titles;
    _cycleScrollView.titleLabelBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_Bottombutton"]];
}

- (void)configSubviews {
    _nameLabel.text = _goods.goods_name;
    _briefLabel.text = _goods.goods_brief;
    _descLabel.text = _goods.goods_desc;
    _priceLabel.text = [NSString stringWithFormat:@"￥ %@", _goods.goods_market_price];
    _falsePriceLabel.text = [NSString stringWithFormat:@"￥ %@", _goods.goods_shop_price];
    _falsePriceLabel.attributedText = [HSDataFormatHandle addStrikethroughTo:_falsePriceLabel.text];
//    _falsePriceLabel.hidden = YES;
//    _carriageLabel.text = @""; //邮费？
//    _dateLabel.text = @"剩余 2天 11小时 11分 11秒";
//    _dateLabel.hidden = YES;
    _countLabel.text = [NSString stringWithFormat:@"还剩 %@ 件", _goods.goods_number];
//    _countLabel.hidden = YES;
    //    [_likeBtn setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)buyBtnClick:(UIButton *)sender {
    
    ShowHud(@"未知错误", NO);
    return;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/goods/%@/goods_order", [HSHttpRequestTool userToken], self.goods.goods_id];
    NSDictionary *para = @{@"goods_order_number": @(_selectGoodsCountView.count)};
    
    [HSHttpRequestTool POST:urlStr parameters:para success:^(id responseObject) {
        ShowHud(@"订单成功！", NO);
    } failure:^(NSString *error) {
        ShowHud(error, NO);
    }];
}

@end
