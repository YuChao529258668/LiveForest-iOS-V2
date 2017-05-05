//
//  HSShaiTuActivityShareListController.m
//  LiveForest
//
//  Created by 余超 on 16/3/2.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSShaiTuActivityShareListController.h"

// controller
#import "HSShareDetailController.h"
#import "HSCreateShareController.h"
#import "HSCreateYueBanController.h"
#import "HSCreateChallengeController.h"

// view
#import "SDCycleScrollView.h"
#import "HSSportsCell.h"

#import "MJRefresh.h"
#import "HSHttpRequestTool.h"

// model
#import "HSRecommendShareModel.h"
#import "HSOfficialDisplayPictureActivity.h"

static int pageNum = 1;
static int pageSize = 10;

@interface HSShaiTuActivityShareListController ()
@property (nonatomic, strong) NSMutableArray *recommendShares;
@end

@implementation HSShaiTuActivityShareListController

static NSString *reuseIdentifier = @"HSSportsCell";

#pragma mark - Initial
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMJRefresh];
    
    self.recommendShares = [NSMutableArray array];
    
//    [self.navigationItem.leftBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"btn_chevron left_n"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_chevron left_n"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = right;
//    [self.navigationController.navigationBar.backItem.backBarButtonItem setBackgroundImage:[UIImage imageNamed:@"btn_chevron left_n"]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    if (path) {
//        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];    

    [self.tableView reloadData];
}

#pragma mark - DataSource

//http://doc.live-forest.com/share/#_54
- (void)loadNewData {
    NSString *activityID = _activity.activity_id? : @"";

    [HSOfficialDisplayPictureActivity getShareListWithActivityID:activityID PageNum:1 PageSize:pageSize Success:^(NSArray *shares) {
        [self handleNewData:shares];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (void)loadMoreData {
    pageNum ++;
    
    [HSOfficialDisplayPictureActivity getShareListWithActivityID:_activity.activity_id PageNum:pageNum PageSize:pageSize Success:^(NSArray *activitys) {
        [self handleMoreData:activitys];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_footer endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];    
}

#pragma mark - Setup

- (void)setUpMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendShares.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSportsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.recommendShareModel = self.recommendShares[indexPath.row];
    cell.postShareLikeBlock = ^(NSString *shareID) {
        [HSHttpRequestTool postShareLike:shareID success:^{
            HSLog(@"%s,%@",__func__, @"点赞成功");
        } failure:^(NSString *error) {
            HSLog(@"%s,%@",__func__, error);
        }];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 注意: 用不同的控制器创建的控制器对象是不一样的，和用alloc init创建的也不一样。比如控制器的cell有个reuseIdentifier，不同的故事板的reuseIdentifier可能不同。如果是通过代码创建控制器对象就要自己为cell注册reuseIdentifier。不然dequeueReusableCellWithIdentifier会报异常。
    
    //    HSShareDetailController *vc = [HSShareDetailController new];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSShareDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShareDetailController"];
    
    vc.recommendShareModel = self.recommendShares[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper

- (void)handleNewData:(NSArray *)array {
    if (self.recommendShares.firstObject) { // 非首次加载数据
        NSUInteger index = [array indexOfObject:self.recommendShares.firstObject];
        //            HSLog(@"index = %lu",(unsigned long)index);
        if (index == NSNotFound) {
            index = array.count;
        }
        NSRange range =  NSMakeRange(0, index);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray *subArray = [array subarrayWithRange:range];
        [self.recommendShares insertObjects:subArray atIndexes:indexSet];
    } else {    // 首次加载数据
        self.recommendShares = [NSMutableArray arrayWithArray:array];
    }
}

- (void)handleMoreData:(NSArray *)array {
    NSRange range =  NSMakeRange(self.recommendShares.count, array.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.recommendShares insertObjects:array atIndexes:indexSet];
}

@end
