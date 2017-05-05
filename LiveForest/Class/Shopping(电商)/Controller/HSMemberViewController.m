//
//  HSMemberViewController.m
//  LiveForest
//
//  Created by 余超 on 16/8/8.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

typedef NS_ENUM(NSInteger, HSTableViewSection) {
    HSTableViewSectionShopTheme = 0,
    HSTableViewSectionShopThemeContent = 1
};

#import "HSShopTheme.h"
#import "HSGoods.h"

#import "HSShopThemeCell.h"
#import "HSShopThemeContentCell.h"

#import "HSMemberViewController.h"
#import "HSGoodsDetailController.h"
#import "HSCoachDetailViewController.h"

@interface HSMemberViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<__kindof HSGoods *> *goodsList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, assign) BOOL shouldHideNavigationBar;
@end

@implementation HSMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    
    self.goodsList = [NSMutableArray new];
    NSArray *images = @[@"http://img01.taopic.com/150128/318761-15012Q0242474.jpg",@"http://img.juimg.com/tuku/yulantu/131223/328254-13122312140354.jpg",@"http://photocdn.sohu.com/20150327/mp8238371_1427432930276_5.jpeg",@"http://img01.taopic.com/150128/318761-15012Q0310425.jpg"];
    NSArray *names = @[@"体院专业教练", @"市队专业教练", @"省队专业教练", @"国家专业教练"];
    NSArray *brief = @[@"HllT能使身体在训练之后也继续保持高效的燃脂状态",@"HllT能使身体在训练之后也继续保持高效的燃脂状态",@"HllT能使身体在训练之后也继续保持高效的燃脂状态",@"HllT能使身体在训练之后也继续保持高效的燃脂状态"];
    NSArray *shopPrice = @[@"100", @"200", @"300", @"400"];
    NSArray * marketPrice= @[@"80",@"180",@"280",@"380"];
    
    for (int i = 0; i < 4; i++) {
        HSGoods *goods = [HSGoods new];
        goods.goodsImageURLs = [NSMutableArray arrayWithObject:images[i]];
        goods.goods_name = names[i];
        goods.goods_brief = brief[i];
        goods.goods_market_price = marketPrice[i];
        goods.goods_shop_price = shopPrice[i];
        [self.goodsList addObject:goods];
    }

//    self.shouldHideNavigationBar = self.navigationController.toolbarHidden;
}

#pragma mark - Life Cycle

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:_shouldHideNavigationBar animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case HSTableViewSectionShopThemeContent:
            return self.goodsList.count;
        case HSTableViewSectionShopTheme:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HSTableViewSectionShopTheme) {
        HSShopThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSShopThemeCell" forIndexPath:indexPath];
        cell.goodsTheme = self.shopTheme;
        return cell;
    } else if (indexPath.section == HSTableViewSectionShopThemeContent) {
        HSShopThemeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSShopThemeContentCell" forIndexPath:indexPath];
        cell.goods = self.goodsList[indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    商品主题不给点击，只许点击主题的内容的cell
    if (indexPath.section == HSTableViewSectionShopTheme) {
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Shopping" bundle:nil];
    HSCoachDetailViewController *vc = (HSCoachDetailViewController *)[sb instantiateViewControllerWithIdentifier:@"HSCoachDetailViewController"];
    vc.goods = self.goodsList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HSTableViewSectionShopThemeContent:
            return 144;
        case HSTableViewSectionShopTheme:
            return 216;
        default:
            return 0;
    }
}

@end
