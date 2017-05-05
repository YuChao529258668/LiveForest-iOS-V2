//
//  HSShopHomeViewController.m
//  LiveForest
//
//  Created by 余超 on 15/11/26.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

// controller
#import "HSShopHomeViewController.h"
#import "HSShopThemeController.h"
#import "HSGoodsDetailController.h"
#import "HSMemberViewController.h"

#import "SDCycleScrollView.h"
#import "HSShopThemeCell.h"

#import "HSShopTheme.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "HSHttpRequestTool.h"
#import "UIViewController+HSBarItem.h"
#import "UIStoryboard+HSController.h"


typedef NS_ENUM(NSInteger, HSTableViewRow) {
    HSTableViewRowScore = 0,
    HSTableViewRowShoes = 1
};


@interface HSShopHomeViewController () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray<__kindof HSShopTheme *> *goodsThemes;
@end


@implementation HSShopHomeViewController

#pragma mark - Initial
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goodsThemes = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
//    [self setUpCycleScrollView];
    
//    [self setUpMJRefresh];
    [self loadNewData];

    // 设置导航栏菜单
//    self.navigationItem.leftBarButtonItem = self.navigationController.navigationItem.leftBarButtonItem;
//    self.navigationItem.rightBarButtonItems = self.navigationController.navigationItem.rightBarButtonItems;
    UIBarButtonItem *notifyItem = [self hs_itemWithNormal:@"btn_note_n" Selected:@"btn_note_h" target:self action:@selector(notififationBtnClick:)];
    self.navigationItem.rightBarButtonItem = notifyItem;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - DataSource
- (void)loadNewData {
    
    // 用于演示
    self.goodsThemes = [HSShopTheme test];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    return;
    
    
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/goods_theme", [HSHttpRequestTool userToken]];
    NSDictionary *para = @{};
    
    [HSHttpRequestTool GET:urlstr parameters:para success:^(id responseObject) {
        NSDictionary *goods_theme = [responseObject valueForKey:@"goods_themes"];
        self.goodsThemes = [HSShopTheme mj_objectArrayWithKeyValuesArray:goods_theme];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
    
}
#pragma mark - Setup
- (void)setUpMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setUpCycleScrollView {
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"感谢您的支持",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com",
                        @"感谢您的支持"
                        ];
    
    CGFloat width = self.view.bounds.size.width;
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 320, width, 252) imageURLStringsGroup:imagesURLStrings];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    self.tableView.tableHeaderView = cycleScrollView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:     return 1;
            break;
        default:     return self.goodsThemes.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 假数据 会员
        HSShopTheme *goodsTheme = [HSShopTheme new];
        goodsTheme.goods_theme_title = @"专业服务";
        goodsTheme.goods_theme_description = @"专业教练亲自为您训练";
        goodsTheme.goodsThemeLogoURL = [NSURL URLWithString:@"http://img01.taopic.com/150128/318761-15012Q0310425.jpg"];
        
        HSShopThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSShopThemeCell" forIndexPath:indexPath];
        cell.goodsTheme = goodsTheme;
        return cell;

    } else {
        HSShopThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSShopThemeCell" forIndexPath:indexPath];
        cell.goodsTheme = self.goodsThemes[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Shopping" bundle:nil];
    
    if (indexPath.section == 0) { // 会员健身
        // 假数据 会员
        HSShopTheme *goodsTheme = [HSShopTheme new];
        goodsTheme.goods_theme_title = @"专业服务";
        goodsTheme.goods_theme_description = @"专业教练亲自为您训练";
        goodsTheme.goodsThemeLogoURL = [NSURL URLWithString:@"http://img01.taopic.com/150128/318761-15012Q0310425.jpg"];

        HSMemberViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HSMemberViewController"];
        vc.shopTheme = goodsTheme;
        [self.navigationController pushViewController:vc animated:YES];

    } else { // 商品
        switch (indexPath.row) {
            case HSTableViewRowScore: {
                HSShopThemeController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShopThemeController"];
                vc.shopTheme = self.goodsThemes[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case HSTableViewRowShoes: {
                HSShopThemeController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShopThemeController"];
                vc.shopTheme = self.goodsThemes[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HSLog(@"点击了第 %ld 张图片",(long)index);
}

#pragma mark - Actions
- (void)notififationBtnClick:(UIButton *)btn {
    UIViewController *vc = [UIStoryboard hs_controllerOfName:@"HSNotificationListController" storyBoard:@"Personal"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
