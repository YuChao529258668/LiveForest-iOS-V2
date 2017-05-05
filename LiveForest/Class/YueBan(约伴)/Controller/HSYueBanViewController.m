//
//  HSYueBanViewController.m
//  LiveForest
//
//  Created by 余超 on 15/11/26.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSYueBanViewController.h"

#import "HSHttpRequestTool.h"
#import "NSObject+HSJson.h"
#import "UIViewController+HSShow.h"

//controller
#import "HSCreateChallengeController.h"
#import "HSCreateYueBanController.h"
#import "HSCreateShareController.h"
#import "HSChallengeDetailController.h"

//view
#import "HSYueBanTableViewCell.h"
#import "YCBubbleMenu.h"

//model
#import "HSYueBanModel.h"
#import "HSChallengeModel.h"

//Lib
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface HSYueBanViewController ()<YCBubbleMenuDelegate>
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *yueBanModels;
@property (nonatomic, strong) NSMutableArray *challenges;
@property (nonatomic, strong) YCBubbleMenu *bubbleMenu;
@end


@implementation HSYueBanViewController 

static NSString *reuseIdentifier = @"YueBanCell";

#pragma mark - Initial
- (void)viewDidLoad {
    [super viewDidLoad];

    self.yueBanModels = [NSMutableArray array];
    self.challenges = [NSMutableArray array];
    
    [self setUpMJRefresh];
    [self setupYCbubbleMenu];
    
    // 把多余的空白cell去掉
    self.tableView.tableFooterView = [UIView new];

    // 设置导航栏菜单
//    self.navigationItem.leftBarButtonItem = self.navigationController.navigationItem.leftBarButtonItem;
    self.navigationItem.rightBarButtonItems = self.navigationController.navigationItem.rightBarButtonItems;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.selectedIndexPath && self.challenges) {
        HSChallengeModel *model = self.challenges[_selectedIndexPath.row];
        if (model.isAttend) {
            _selectedIndexPath = nil;
            [self.challenges removeObject:model];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - DataSource
/// 获取待参加的挑战列表
- (void)getChallengesNotAttend {
    [HSChallengeModel getChallengesNotAttendSuccess:^(NSArray *models) {
        HSLog(@"%s, challenges.count ＝ %ld", __func__, models.count);
        self.challenges = models.mutableCopy;
        
        if (models==nil || models.count == 0) {
            UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            self.tableView.tableFooterView = label;
        } else {
            self.tableView.tableFooterView = nil;
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,error = %@", __func__, error);
        
        if (self.challenges==nil || self.challenges.count == 0) {
            UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            self.tableView.tableFooterView = label;
        } else {
            self.tableView.tableFooterView = nil;
        }

    }];
}

/// 获取陌生人的约伴列表
- (void)getYueBanListFromStranger {
    // 获取陌生人的约伴列表
    NSString *urlStr = @"http://api.liveforest.com/Social/YueBan/getYueBanListFromStrangers";
    
    [HSHttpRequestTool GET:urlStr success:^(id responseObject) {
        HSLog(@"yuebanList ＝ %@",[responseObject objectForKey:@"yuebanList"]);
        NSDictionary *yuebanList = [responseObject objectForKey:@"yuebanList"];
        self.yueBanModels = [HSYueBanModel mj_objectArrayWithKeyValuesArray:yuebanList];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"error = %@",error);
    }];
}

- (void)loadNewData {
    // 用于演示

//    [self getChallengesNotAttend];
    
    self.challenges = [HSChallengeModel test];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];

}

//- (void)loadMoreData {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView.mj_footer endRefreshing];
//    });
////    未完成
//}

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

//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.yueBanModels.count;
    return self.challenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSYueBanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"pushToHSChallengeDetailController" sender:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@",NSStringFromCGRect(self.bubbleMenu.frame));
    
//    固定气泡菜单，不随着滚动。
    CGPoint offset = scrollView.contentOffset;
    _bubbleMenu.transform = CGAffineTransformMakeTranslation(0, offset.y);
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    如果是跳转到挑战详情界面
    if ([segue.identifier isEqualToString:@"pushToHSChallengeDetailController"]) {
        NSIndexPath *path = (NSIndexPath *)sender;
        HSChallengeDetailController *vc = (HSChallengeDetailController *)segue.destinationViewController;
        vc.challengeModel = self.challenges[path.row];
        vc.userStyle = HSChallengeUserStylePlayer;
    }
}

#pragma mark - Private
- (void)configureCell:(HSYueBanTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.yueBanModel = self.yueBanModels[indexPath.row];
    cell.challengeModel = self.challenges[indexPath.row];
    cell.agreeBtnClickBlock = ^(HSYueBanTableViewCell *cell) {
        [cell.challengeModel attendChallengeSuccess:^{
            ShowHint(@"参与成功");
            [self.challenges removeObject:cell.challengeModel];
            [self.tableView reloadData];
        } failure:^(NSString *error) {
            ShowHint(error);
        }];
    };
    cell.refuseBtnClickBlock = ^(HSYueBanTableViewCell *cell) {
        [cell.challengeModel refuseChallengeSuccess:^{
            ShowHint(@"已忽略");
            [self.challenges removeObject:cell.challengeModel];
            [self.tableView reloadData];
        } failure:^(NSString *error) {
            ShowHint(error);
        }];
    };
}

@end
