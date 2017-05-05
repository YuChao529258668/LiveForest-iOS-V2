//
//  HSShareDetailController.m
//  LiveForest
//
//  Created by 余超 on 15/12/24.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSShareDetailController.h"
#import "HSCommentListController.h"
#import "HSPersonalHomePageController.h"

//view
#import "HSShareDetailCell.h"
#import "HSShareDetailCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YCCycleScrollView.h"
#import "HSShareDetailBar.h"

#import "HSShareCommentModel.h"
#import "HSRecommendShareModel.h"
#import "HSChallengeModel.h"

typedef NS_ENUM (NSInteger, HSTableViewSection) {
    HSTableViewSectionShareDetail = 0,
    HSTableViewSectionChallenges = 1,
    HSTableViewSectionComments = 2
};

NSUInteger sectionCount = 3;


@interface HSShareDetailController ()<UITableViewDelegate, UITableViewDataSource, HSShareDetailBarDelegate>
@property (nonatomic, strong) NSArray<__kindof HSChallengeModel *> *challenges;
@property (nonatomic, strong) NSArray<__kindof HSShareCommentModel *> *comments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *challengeView;
@property (nonatomic, strong) YCCycleScrollView *cycleScrollView;
@property (nonatomic, strong) HSShareDetailBar *shareDetailBar;
@end


@implementation HSShareDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.comments = [NSArray array];
    self.challenges = [NSArray array];
    
    [self setupChallengeView];
    [self setupShareDetailbar];

    // 不让 shareDetailbar 挡住 Tableview 底部的内容
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:self.shareDetailBar.bounds];
    
//    [self getCommentList];
    [self getChallenge];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self getCommentList]; // 如果增加了评论，懒得创建评论对象了，重新获取评论吧
}

#pragma mark - Setup

- (void)setupChallengeView {
    CGRect frame = CGRectZero;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = 22 + 8 + (142 + 12 + 8); // 前面的8和12是间距,192
    
    UIView *cv = [[UIView alloc]initWithFrame:frame];
//    cv.backgroundColor = [UIColor blueColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 22)];
    label.text = @"关联的挑战";
    label.font = [UIFont systemFontOfSize:16];
    [cv addSubview:label];
    
    frame.origin.y = 22 + 8;
    frame.size.height = 142 + 12 + 8;
    [self setupYCCycleScrollViewWithFrame:frame];
    [cv addSubview:_cycleScrollView];
    
    _challengeView = cv;
}

- (void)setupYCCycleScrollViewWithFrame:(CGRect)frame {
    YCCycleScrollView *sv = [[YCCycleScrollView alloc]initWithFrame:frame];
    sv.canSelectCell = NO;
    _cycleScrollView = sv;
}

- (void)setupShareDetailbar {
    float height = 84;
    float y = [UIScreen mainScreen].bounds.size.height - height;
    float width = [UIScreen mainScreen].bounds.size.width;
    CGRect frame = CGRectMake(0, y, width, height);
    
    HSShareDetailBar *bar = [HSShareDetailBar barWithFrame:frame delegate:self];
    [self.view addSubview:bar];
    bar.delegate = self;
    _shareDetailBar = bar;
    
    _shareDetailBar.likeBtn.selected = _recommendShareModel.hasLiked;
}

#pragma mark - Set
- (void)setRecommendShareModel:(HSRecommendShareModel *)recommendShareModel {
    _recommendShareModel = recommendShareModel;
    _shareID = recommendShareModel.share_id;
}

#pragma mark - Data Source
- (void)getCommentList {
    [HSShareCommentModel getCommentListWithShareID:_shareID Success:^(NSArray *models) {
        self.comments = models;
        self.recommendShareModel.comment_count = [NSString stringWithFormat:@"%lu", (unsigned long)models.count]; // 修改评论数
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

- (void)getChallenge {
    
    // 用于演示
    self.challenges = [HSChallengeModel test];
    self.cycleScrollView.models = self.challenges;
    [self.tableView reloadData];
    return;
    
    [HSChallengeModel getChallengeWithShareID:_shareID Success:^(NSArray *models) {
        self.challenges = models;
        self.cycleScrollView.models = models;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
        self.challenges = @[];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == HSTableViewSectionShareDetail) {
        return 1;
    } else if (section == HSTableViewSectionComments) {
        return self.comments.count;
    } else if (section == HSTableViewSectionChallenges) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case HSTableViewSectionShareDetail: {
            HSShareDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSShareDetailCell" forIndexPath:indexPath];
            cell.recommendShareModel = self.recommendShareModel;
            cell.postShareLikeBlock = ^(NSString *shareID) {
                [HSHttpRequestTool postShareLike:shareID success:^{
                    HSLog(@"%s,%@",__func__, @"点赞成功");
                    _shareDetailBar.likeBtn.selected = !_shareDetailBar.likeBtn.isSelected;
                } failure:^(NSString *error) {
                    HSLog(@"%s,%@",__func__, error);
                }];
            };
            return cell;
        }
        case HSTableViewSectionComments: {
            HSShareDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSShareDetailCommentCell" forIndexPath:indexPath];
            cell.model = self.comments[indexPath.row];
            return cell;
        }
        case HSTableViewSectionChallenges: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challenge"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"challenge"];
            }
            [cell.contentView addSubview:self.challengeView];
            return cell;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark - Table view delegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HSTableViewSectionComments:
            return 78;
            break;
        case HSTableViewSectionShareDetail:
            return 528;
            break;
        case HSTableViewSectionChallenges:
            return 200;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - HSShareDetailBarDelegate

- (void)HSShareDetailBar:(HSShareDetailBar *)bar backButtonClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)HSShareDetailBar:(HSShareDetailBar *)bar likeButtonClick:(UIButton *)btn {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:HSTableViewSectionShareDetail];
    HSShareDetailCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell likeBtnClick];
}

- (void)HSShareDetailBar:(HSShareDetailBar *)bar commentButtonClick:(UIButton *)btn {
    HSCommentListController *vc = [HSCommentListController new];
    vc.shareID = _recommendShareModel.share_id;
//    vc.commentSuccessBlock = ^(NSString *comment) {
//        
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)HSShareDetailBar:(HSShareDetailBar *)bar personButtonClick:(UIButton *)btn {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    HSPersonalHomePageController *vc = [sb instantiateViewControllerWithIdentifier:@"HSPersonalHomePageController"];
    vc.userID = _recommendShareModel.user_id;
//    vc.backBtn.hidden = NO;
    vc.shouldHideBackBtn = NO;
    vc.shouldHideAttentionBtn = NO;
    vc.shouldHidePersonDetailBtn = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)makeCommentModel:(NSString *)comment {
//    HSShareCommentModel *model = [HSShareCommentModel new];
//    model.share_comment_content = comment;
//    model.share_comment_create_time = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
//    user_logo_img_path
//    user_nickname
//    comment_id
//    isReply
//}

#pragma mark - Actions
// 举报按钮
- (IBAction)juBaoBtnClick:(UIButton *)sender {
    ShowHint(@"举报成功");
}


@end
