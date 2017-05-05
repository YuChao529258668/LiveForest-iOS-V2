//
//  HSPersonalHomePageController.m
//  LiveForest
//
//  Created by 余超 on 16/1/5.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

typedef NS_ENUM(NSInteger ,HSTableViewSection) {
    HSTableViewSectionHead = 0,
    HSTableViewSectionShare = 1
};

#import "HSPersonalHomePageController.h"
#import "HSPersonalDetailController.h"
#import "HSShareDetailController.h"
#import "HSChallengeEventFlowController.h"

#import "HSPersonalHeadCell.h"
#import "HSSportsCell.h"
#import "HSBackButton.h"

#import "HSRecommendShareModel.h"
#import "HSUserModel.h"

#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>

static int requestNum = 10;


@interface HSPersonalHomePageController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *shares;

@end


@implementation HSPersonalHomePageController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldHideBackBtn = YES;
        _shouldHideAttentionBtn = YES;
        _shouldHidePersonDetailBtn = NO;
//        _userID = [HSUserModel userID];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _shouldHideBackBtn = YES;
        _shouldHideAttentionBtn = YES;
        _shouldHidePersonDetailBtn = NO;
//        _userID = [HSUserModel userID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserInfo];
    
    self.shares = [NSMutableArray array];

    self.backBtn.hidden = _shouldHideBackBtn;
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 500; // 必须必6plus的cell的高度要相等，不然6plus运行，控制器重新显示的时候会滚动到别的位置。。。
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    if (path) {
//        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    }
    
    [self.tableView reloadData];
    
//    [HSUserTool setUserAvatar:self.avatarImageView];

}

- (void)viewDidLayoutSubviews {
    // 有tabbar，tableview的高度会预留，这样tabbar就不透明了。而且这个tableView不是控制器的rootView，设置automaticallyAdjustsScrollViewInsets无效。
    _tableView.frame = [UIScreen mainScreen].bounds;
}

- (void)setUpMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case HSTableViewSectionShare:
            return _shares.count;
        case HSTableViewSectionHead:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HSTableViewSectionShare) {
        HSSportsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSSportsCell" forIndexPath:indexPath];
        cell.recommendShareModel = self.shares[indexPath.row];
        cell.postShareLikeBlock = ^(NSString *shareID) {
            [HSHttpRequestTool postShareLike:shareID success:^{
                HSLog(@"%s,%@",__func__, @"点赞成功");
            } failure:^(NSString *error) {
                HSLog(@"%s,%@",__func__, error);
            }];
        };
        cell.moreContentsBtnClickBlock = ^ {
            HSChallengeEventFlowController *vc = [HSChallengeEventFlowController challengeEventFlowController];
            vc.shareModel = self.shares[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        };

        return cell;
    } else if (indexPath.section == HSTableViewSectionHead) {
        HSPersonalHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSPersonalHeadCell" forIndexPath:indexPath];
        if ([_userID isEqualToString:[HSUserModel currentUser].user_id]) {
                _shouldHideAttentionBtn = YES;
                _shouldHidePersonDetailBtn = NO;
        }

        cell.attentionBtn.hidden = self.shouldHideAttentionBtn;
        cell.canLookPersonDetail = !self.shouldHidePersonDetailBtn;
        HSUserModel *user = self.user;
        cell.userID = user.user_id;
//        cell.attentionBtn.selected =
        cell.nameLabel.text = user.user_nickname;
        cell.contentLabel.text = user.user_sign;
        [cell.avatarImageView sd_setImageWithURL:[NSURL hs_URLWithString:user.user_logo_img_path] placeholderImage:cell.avatarImageView.image];
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    后面的界面可能会修改用户信息，所以要更新第一个section的cell
    if (indexPath.section == HSTableViewSectionHead && [cell isKindOfClass:[HSPersonalHeadCell class]]) {
        HSPersonalHeadCell *cell2 = (HSPersonalHeadCell *)cell;
        HSUserModel *user = self.user;
        cell2.nameLabel.text = user.user_nickname;
        cell2.contentLabel.text = user.user_sign;
//        [cell2.avatarImageView sd_setImageWithURL:[NSURL hs_URLWithString:user.user_logo_img_path] placeholderImage:cell2.avatarImageView.image];
//        if ([HSUserModel currentUser].modifyAvatar) {
//            cell2.avatarImageView.image = [HSUserModel currentUser].modifyAvatar;
//        }
        if ([HSUserModel currentUser].modifyAvatarData) {
            cell2.avatarImageView.image = [UIImage imageWithData:[HSUserModel currentUser].modifyAvatarData];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HSTableViewSectionShare:
//            return 273;
            return UITableViewAutomaticDimension;
        case HSTableViewSectionHead:
            return 146;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HSTableViewSectionHead) {
        return;
    }
    
    // 注意: 用不同的控制器创建的控制器对象是不一样的，和用alloc init创建的也不一样。比如控制器的cell有个reuseIdentifier，不同的故事板的reuseIdentifier可能不同。如果是通过代码创建控制器对象就要自己为cell注册reuseIdentifier。不然dequeueReusableCellWithIdentifier会报异常。
    
    //    HSShareDetailController *vc = [HSShareDetailController new];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSShareDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShareDetailController"];
    vc.recommendShareModel = self.shares[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Data Source
- (void)getUserInfo {
    
    // 用于演示
    _user = [HSUserModel test];
    [self setUpMJRefresh];
    return;
    
    
    if (_user == nil && _userID == nil) { // 默认是加载当前用户的信息
        _user = [HSUserModel currentUser];
        [self setUpMJRefresh];
    } else if (_userID && _user == nil) { // 如果外面只传了user_id，就从后台获取用户信息
        [HSUserModel getUserInfoWithUserID:_userID success:^(HSUserModel *userInfo) {
            _user = userInfo;
            [self setUpMJRefresh];
            [self loadNewData]; // 根据user获取相关数据
        } failure:^(NSString *error) {
            HSLog(@"%s,%@",__func__, error);
            ShowHint(@"获取用户信息失败");
        }];
    }
}

/// 根据属性user的user_id获取数据
- (void)loadNewData {
    
    // 用于演示
    self.shares = [HSRecommendShareModel test];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

    return;
    
    
    
    [HSRecommendShareModel getUserShareListWithUserID:self.user.user_id shareID:0 requestNum:requestNum Success:^(NSArray *activitys) {
        NSArray *array = activitys;
        if (self.shares.firstObject) { // 非首次加载数据
            NSUInteger index = [array indexOfObject:self.shares.firstObject];
            //            HSLog(@"index = %lu",(unsigned long)index);
            if (index == NSNotFound) {
                index = array.count;
            }
            NSRange range =  NSMakeRange(0, index);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            NSArray *subArray = [array subarrayWithRange:range];
            [self.shares insertObjects:subArray atIndexes:indexSet];
        } else {    // 首次加载数据
            self.shares = [NSMutableArray arrayWithArray:array];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];
}

/// 根据属性user的user_id获取数据
- (void)loadMoreData {
    [HSRecommendShareModel getUserShareListWithUserID:self.user.user_id shareID:(int)_shares.count requestNum:requestNum Success:^(NSArray *activitys) {
        NSArray *array = activitys;
        
        NSRange range =  NSMakeRange(self.shares.count, array.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.shares insertObjects:array atIndexes:indexSet];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];
}


#pragma mark - 界面跳转

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToHSPersonalDetailController"]) {
        HSPersonalDetailController *vc = segue.destinationViewController;
        vc.user = self.user;
    }
}

@end
