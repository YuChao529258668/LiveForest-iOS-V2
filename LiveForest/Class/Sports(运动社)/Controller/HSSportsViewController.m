//
//  HSSportsViewController.m
//  LiveForest
//
//  Created by 余超 on 15/11/26.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSSportsViewController.h"

// controller
#import "HSShareDetailController.h"
#import "HSCreateShareController.h"
#import "HSCreateYueBanController.h"
#import "HSCreateChallengeController.h"
#import "HSShaiTuActivityShareListController.h"
#import "HSChallengeEventFlowController.h"

// view
#import "SDCycleScrollView.h"
#import "HSSportsCell.h"
#import "YCBubbleMenu.h"
#import "HSNavigationMenu.h"

// model
#import "HSRecommendShareModel.h"
#import "HSOfficialDisplayPictureActivity.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIViewController+HSShow.h"
#import "NSObject+HSJson.h"
#import "HSHttpRequestTool.h"
#import "UIViewController+HSBarItem.h"
#import "UIStoryboard+HSController.h"

static NSString *reuseIdentifier = @"HSSportsCell";
static int pageNum = 1;
static int pageSize = 10;

@interface HSSportsViewController () <SDCycleScrollViewDelegate, YCBubbleMenuDelegate>
@property (nonatomic, strong) NSMutableArray *recommendShares;
@property (nonatomic, strong) NSArray *officialDisplayPictureActivitys;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) YCBubbleMenu *bubbleMenu;

@end


@implementation HSSportsViewController

#pragma mark - Initial
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCycleScrollView];
    [self setUpMJRefresh];
    [self setupYCbubbleMenu];
    
    self.recommendShares = [NSMutableArray array];
    self.officialDisplayPictureActivitys = [NSMutableArray array];
    
    [self getOfficialDisplayPictureActivitys];
    
    // 设置导航栏菜单
//    self.navigationItem.leftBarButtonItem = self.navigationController.navigationItem.leftBarButtonItem;
//    self.navigationItem.rightBarButtonItems = self.navigationController.navigationItem.rightBarButtonItems;
    UIBarButtonItem *notifyItem = [self hs_itemWithNormal:@"btn_note_n" Selected:@"btn_note_h" target:self action:@selector(notififationBtnClick:)];
    self.navigationItem.rightBarButtonItem = notifyItem;

    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 528; // 必须必6plus的cell的高度要相等，不然6plus运行，控制器重新显示的时候会滚动到别的位置。。。
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    if (path) {
//        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    }
    
    [self.tableView reloadData];
    
}

#pragma mark - DataSource
- (void)getOfficialDisplayPictureActivitys {
    // 用于演示
    self.officialDisplayPictureActivitys = [HSOfficialDisplayPictureActivity test];
    NSMutableArray *imageURLs = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (HSOfficialDisplayPictureActivity *model in self.officialDisplayPictureActivitys) {
        [imageURLs addObject: model.activity_img_path[0]];
        [titles addObject:model.activity_summary];
    }
    self.cycleScrollView.imageURLStringsGroup = imageURLs;
    self.cycleScrollView.titlesGroup = titles;
    [self.tableView reloadData];
    
    return;
    
    
    [HSOfficialDisplayPictureActivity getActivityListSuccess:^(NSArray *activitys) {
        self.officialDisplayPictureActivitys = activitys;
        
        
        NSMutableArray *imageURLs = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        for (HSOfficialDisplayPictureActivity *model in self.officialDisplayPictureActivitys) {
            [imageURLs addObject: model.activity_img_path[0]];
            [titles addObject:model.activity_summary];
        }
        self.cycleScrollView.imageURLStringsGroup = imageURLs;
        self.cycleScrollView.titlesGroup = titles;

        [self.tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,error = %@",__func__, error);
    }];
}

- (void)loadNewData {
    // 用于演示
    self.recommendShares = [HSRecommendShareModel test];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    return;
    
    
    
    [HSRecommendShareModel getRecommendShareListWithPageNum:1 PageSize:pageSize Success:^(NSArray *models) {
        NSArray *array = models;
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
//            if (array.count == 0) {
//                
//            }
            self.recommendShares = [NSMutableArray arrayWithArray:array];

//            if (self.recommendShares.firstObject == nil) {
//                
//            }
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (void)loadMoreData {
//    因为每次获取的数据都是一样的，所以先把代码注释掉
    /*
    pageNum ++;
    
    [HSRecommendShareModel getRecommendShareListWithPageNum:pageNum PageSize:pageSize Success:^(NSArray *models) {
        NSArray *array = models;
        
        NSRange range =  NSMakeRange(self.recommendShares.count, array.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.recommendShares insertObjects:array atIndexes:indexSet];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];    
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - Setup
- (void)setupYCbubbleMenu {
    float height = 70;
    float x = [UIScreen mainScreen].bounds.size.width * 0.75;
    float y = self.tabBarController.tabBar.frame.origin.y - 20 - height;
    CGRect frame = CGRectMake(x, y, height, height);
    UIImage *normal = [UIImage imageNamed:@"btn_fab_n"];
    UIImage *selected = [UIImage imageNamed:@"btn_fab_h"];
    
    //    __weak ViewController *weakself = self;
    YCBubbleMenu *menu = [YCBubbleMenu menuWithFrame:frame radius:84 normalImage:normal selectedImage:selected delegate:self];
    
    [menu addButtonWithImage:@"btn_subfabchallenge_n" withAngle:0 clickBlock:^{
        HSCreateChallengeController *challengeController = [[HSCreateChallengeController alloc]init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController hs_showViewController:challengeController];
        challengeController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        challengeController.definesPresentationContext = NO;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:challengeController animated:YES completion:nil];
    }];
    
    [menu addButtonWithImage:@"btn_subfabyueban_n" withAngle:45 clickBlock:^{
//        ShowHint(@"敬请期待");
        HSCreateYueBanController *yueBanController = [[HSCreateYueBanController alloc]init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController hs_showViewController:yueBanController];
        yueBanController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        yueBanController.definesPresentationContext = NO;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:yueBanController animated:YES completion:nil];
    }];
    
    [menu addButtonWithImage:@"btn_subfabshare_n" withAngle:90 clickBlock:^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
        HSCreateShareController *vc = (HSCreateShareController *)[sb instantiateViewControllerWithIdentifier:@"HSCreateShareController"];;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    self.bubbleMenu = menu;
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.bubbleMenu];
    [self.view addSubview:self.bubbleMenu];
}

- (void)setUpMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setUpCycleScrollView {
    CGFloat width = self.view.bounds.size.width;
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, 280) imageURLStringsGroup:nil];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    self.cycleScrollView = cycleScrollView;
    
    self.tableView.tableHeaderView = cycleScrollView;
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
    cell.moreContentsBtnClickBlock = ^ {
        HSChallengeEventFlowController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HSChallengeEventFlowController"];
//        vc.backgroundView = [self.view snapshotViewAfterScreenUpdates:NO];
        vc.shareModel = self.recommendShares[indexPath.row];
//        [self presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(dismissNavigationController)];
//        nav.navigationItem.leftBarButtonItem = back;
//        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        [self presentViewController:nav animated:YES completion:nil];
//        - (void)dismissNavigationController:(UIBarButtonItem *)btn {
//            
//        }

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
//    [self presentViewController:vc animated:YES completion:nil];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  494;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@",NSStringFromCGRect(self.bubbleMenu.frame));
    CGPoint offset = scrollView.contentOffset;
    _bubbleMenu.transform = CGAffineTransformMakeTranslation(0, offset.y);
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HSLog(@"点击了第 %ld 张图片",(long)index);
    HSShaiTuActivityShareListController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HSShaiTuActivityShareListController"];
    vc.activity = self.officialDisplayPictureActivitys[index];
    vc.title = vc.activity.activity_name;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions
- (void)notififationBtnClick:(UIButton *)btn {
    UIViewController *vc = [UIStoryboard hs_controllerOfName:@"HSNotificationListController" storyBoard:@"Personal"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 测试
- (void)save:(NSArray *)array {
    // 1.尝试数组写入硬盘
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //    NSString *filePath = [path stringByAppendingPathComponent:@"sharelist.txt"];
    //    NSLog(@"filePath = %@",filePath);
    //    BOOL success = [array writeToFile:filePath atomically:YES];
    //    NSLog(@"success = %d",success);
    
    // 2.尝试写入userdefault
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sharelist"];
    //    [[NSUserDefaults standardUserDefaults] setObject:@"吃屎" forKey:@"hhhhhhhh"];
    BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
    //    HSLog(@"success = %d",success);
    
    // 3.尝试data写入硬盘
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"sharelist.txt"];
    //    HSLog(@"filePath = %@",filePath);
    
    NSError *error;
    success = [data writeToFile:filePath options:0 error:&error];
    //    HSLog(@"success = %d",success);
    if (error) {
        NSLog(@"%s,%@",__func__,error.localizedDescription);
    }
    
}

- (NSMutableArray *)read {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharelist"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}

@end
