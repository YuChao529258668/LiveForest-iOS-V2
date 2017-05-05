//
//  HSShopThemeController.m
//  LiveForest
//
//  Created by 余超 on 15/12/29.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

typedef NS_ENUM(NSInteger, HSTableViewSection) {
    HSTableViewSectionShopTheme = 0,
    HSTableViewSectionShopThemeContent = 1
};

#import "HSShopThemeController.h"
#import "HSGoodsDetailController.h"

#import "HSShopThemeCell.h"
#import "HSShopThemeContentCell.h"

#import "HSGoods.h"
#import "HSShopTheme.h"

#import "HSHttpRequestTool.h"

@interface HSShopThemeController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<__kindof HSGoods *> *goodsList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HSShopThemeController

#pragma mark - Initial
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getGoodsList];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Life Cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Setup


#pragma mark - Actions


#pragma mark - Data Source
- (void)getGoodsList {
    
    // 用于演示
    self.goodsList = [HSGoods test:self.shopTheme.goods_theme_id];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/goods_theme/%ld", [HSHttpRequestTool userToken], (long)self.shopTheme.goods_theme_id];
    
//    NSString *urlstr = @"http://api.liveforest.com/user/qnZ5awrOszYd1iFb3iLF9DJN2kCJ2B02FgzmX3a2F8gVM83D/goods_theme/0";
    NSDictionary *para = @{@"resource_integration": @[@"goods"]};
    
    [HSHttpRequestTool GET:urlstr parameters:para success:^(id responseObject) {
        NSArray *goods_themes = [responseObject valueForKey:@"goods_themes"];
        NSArray *goodsList = [HSGoods mj_objectArrayWithKeyValuesArray:[goods_themes.firstObject valueForKey:@"goodss"]];
        self.goodsList = goodsList;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];

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
    
    // 判断是否跳转到webView
    NSString *goods_external_link = _goodsList[indexPath.row].goods_external_link;
    if (goods_external_link.length >0) {
        [self jumpToWebViewWithURLStr:goods_external_link];
        return;
    }
    
//    不跳转到webView
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Shopping" bundle:nil];
    HSGoodsDetailController *vc = (HSGoodsDetailController *)[sb instantiateViewControllerWithIdentifier:@"HSGoodsDetailController"];
    vc.goods = self.goodsList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
//    switch (indexPath.row) {
//        case HSTableViewRowScore: {
//            HSShopThemeController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShopThemeController"];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case HSTableViewRowShoes: {
//            HSShopThemeController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShopThemeController"];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//            
//        default:
//            break;
//    }
    
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

- (void)jumpToWebViewWithURLStr:(NSString *)urlStr {
    NSURL *url = [NSURL hs_URLWithString:urlStr];
    
    UIViewController *vc = [UIViewController new];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];
    [vc.view addSubview:webView];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
