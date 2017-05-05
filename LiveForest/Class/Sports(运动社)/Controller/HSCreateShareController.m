//
//  HSCreateShareController.m
//  LiveForest
//
//  Created by 余超 on 15/12/29.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSCreateShareController.h"
#import "HSSelectedFriendController.h"
#import "HSSelectActivityController.h"
#import "HSSelecteSportController.h"

#import "YCCycleScrollView.h"
#import "HSAddPhotoView.h"
#import "YCTextView.h"

#import "HSChallengeModel.h"
#import "HSUserModel.h"
#import "HSOfficialDisplayPictureActivity.h"
#import "HSFriend.h"
#import "HSSportModel.h"

#import "HSCloseKeyboardGesture.h"
#import "HSHttpRequestTool.h"
#import "HSQiniuService.h"
#import "HSLocationTool.h"
#import "HSAreaTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HSCreateShareController ()
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) HSOfficialDisplayPictureActivity *activity;
@property (nonatomic, strong) HSSportModel *sport;

@property (nonatomic, strong) NSArray *challenges;
@property (nonatomic, strong) HSChallengeModel *selectedChallenge;
@property (nonatomic, copy) NSString *challenge_attend_share_id;
@end


@implementation HSCreateShareController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentTextView.placeholder = @"说点什么吧";
    
    [self setupUserInfor];
    [self getChallengeList];
    
    [self setupButtons];
    [self setupGesture];
    
    [HSLocationTool startLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    停止百度地图服务
    [HSLocationTool stopLocation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YCCycleScrollCellCheckButtonClickNotification object:nil];
}

#pragma mark - Setup
- (void)setupUserInfor {
    [self.avatarImageView sd_setImageWithURL:[NSURL hs_URLWithString:[HSUserModel currentUser].user_logo_img_path] placeholderImage:self.avatarImageView.image];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width/2;
    self.avatarImageView.clipsToBounds = YES;
    self.nameLabel.text = [HSUserModel currentUser].user_nickname;
}

- (void)setupButtons {
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupYCCycleScrollView {
//    YCCycleScrollView *sv = [[YCCycleScrollView alloc]initWithFrame:frame];
//    _cycleScrollView = sv;
//    [_challengeView addSubview:sv];
    
    self.challengeView.models = self.challenges;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YCCycleScrollCellCheckButtonClick:) name:YCCycleScrollCellCheckButtonClickNotification object:nil];
}

- (void)setupGesture {
    [self.view addGestureRecognizer:[HSCloseKeyboardGesture gesture]];
}

#pragma mark - Actions
- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)friendsBtnClick:(UIButton *)sender {
    HSSelectedFriendController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HSSelectedFriendController"];
    
    vc.selectedFriends = self.friends;
    vc.completeBlock = ^(NSArray *friends){
        sender.selected = friends.count>0? YES: NO;
        self.friends = [friends copy];
//        for (NSString *s in self.friends) {
//            NSLog(@"%@",s);
//        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)activityBtnClick:(UIButton *)sender {
    HSSelectActivityController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HSSelectActivityController"];
    
    vc.selectedActivity = self.activity;
    vc.completeBlock = ^(HSOfficialDisplayPictureActivity *activity){
        sender.selected = activity? YES: NO;
        self.activity = activity;
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)sportBtnClick:(UIButton *)sender {
    HSSelecteSportController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HSSelecteSportController"];
    
    vc.selectedSport = self.sport;
    vc.completeBlock = ^(HSSportModel *sport){
        sender.selected = sport? YES: NO;
        self.sport = sport;
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

// 点击完成按钮
- (void)completeBtnClick {
//    先判断是否有nil
    if (self.addPhotoView.image == nil) {
        ShowHint(@"请添加图片");
        return;
    }
    if (self.sport == nil) {
        ShowHint(@"请选择运动类型");
        return;
    }
    if (self.friends == nil || self.friends.count <1 || self.friends.count >3) {
        ShowHint(@"请选择1~3个好友");
        return;
    }
    
//    上传图片到七牛，获取URL
    [self uploadImageToQiNiuWithSuccess:^(NSURL *imageURL) {
        [self publishShareWithImageURL:imageURL];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@,上传七牛失败",__func__,error);
    }];
}

- (void)YCCycleScrollCellCheckButtonClick:(NSNotification *)notification {
    HSChallengeModel *model = notification.userInfo[@"HSChallengeModel"];
    if (self.selectedChallenge == model) {
        self.selectedChallenge = nil;
    } else {
        self.selectedChallenge = model;
    }
}

#pragma mark - Business Logic
// 获取我参加的，未完成的挑战，http://doc.live-forest.com/activity/#_18
- (void)getChallengeList {
    [HSChallengeModel getChallengesAttendSuccess:^(NSArray *models) {
        self.challenges = models;
        [self setupYCCycleScrollView];
        self.countLabel.text = [NSString stringWithFormat:@"选择一个未完成的挑战，可以不选"];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
        self.challenges = @[];
        self.countLabel.text = [NSString stringWithFormat:@"暂时没有未完成的挑战！"];
    }];
}

//    上传图片到七牛，获取URL
- (void)uploadImageToQiNiuWithSuccess:(void (^)(NSURL *imageURL))success failure:(void (^)(NSString *error))failure {
    ShowHint(@"正在创建");
    self.completeBtn.enabled = NO;
    
    HSLog(@"%s",__func__);
    HSLog(@"开始上传图片到七牛");
    [HSQiniuService uploadImage:self.addPhotoView.image fileName:self.addPhotoView.imageID requestCB:^(BOOL code, id responseObject, NSString *error) {
        if (responseObject) {
            // 返回的好像是字符串
            HSLog(@"%@",(NSString *)responseObject);
            success(responseObject);
            HSLog(@"%s",__func__);
            HSLog(@"上传七牛成功");
        } else {
            failure(error);
            HSLog(@"%s",__func__);
            HSLog(@"上传七牛失败");
        }
    }];
}

// 发布分享
- (void)publishShareWithImageURL:(NSURL *)imagePath {
    
#warning share_city、share_county、经纬度，可能需要修改
    
    
//  http://doc.live-forest.com/share/#atat1-3
//    内容／相片／关联的未完成的挑战／位置／好友列表／活动／运动
//    运动类型1，活动0或1，好友1-3个，挑战0到1个。
    NSString *user_token = [HSHttpRequestTool userToken];
    NSString *share_category = @"0"; // 0:分享 1:承诺
    NSArray *share_img_path = @[imagePath];
    NSString *share_description = self.contentTextView.text;
    
    HSLocationTool *locationTool = [HSLocationTool locationTool];
    HSAreaTool *areaTool = [HSAreaTool new];
    NSString *share_city = [areaTool areaIDFormatHandleWithProvince:locationTool.addressDetail.province City:locationTool.addressDetail.city District:nil];
    NSString *share_county =  [areaTool areaIDFormatHandleWithProvince:locationTool.addressDetail.province City:locationTool.addressDetail.city District:locationTool.addressDetail.district];;
    NSNumber *share_lon = @(locationTool.longitude);
    NSNumber *share_lat = @(locationTool.latitude);
    NSString *share_location = locationTool.reverseGeoCodeResult.address;
    
    
    NSMutableArray *user_ids = @[].mutableCopy;
    for (HSFriend *friend in self.friends) {
        [user_ids addObject:friend.user_id];
    }

    NSArray *sport_ids = @[self.sport.sportID];
    
    NSMutableDictionary *requestData = @{}.mutableCopy;
    requestData[@"user_token"] = user_token;
    requestData[@"share_city"] = share_city;
    requestData[@"share_county"] = share_county;
    requestData[@"share_lon"] = share_lon;
    requestData[@"share_lat"] = share_lat;
    requestData[@"share_category"] = share_category;
    requestData[@"share_img_path"] = share_img_path;
    requestData[@"share_description"] = share_description;
    requestData[@"share_location"] = share_location;
    requestData[@"user_ids"] = user_ids;
    requestData[@"sport_ids"] = sport_ids;
    if (self.activity) {
        requestData[@"activity_ids"] = @[self.activity.activity_id];
    }
    if (self.selectedChallenge) {
        requestData[@"challenge_ids"] = @[self.selectedChallenge.challenge_id];
    }
    
    NSString *urlstr = @"http://api.liveforest.com/Social/Share/doShareCreateWithAt";
    
    [HSHttpRequestTool GET:urlstr parameters:requestData success:^(id responseObject) {
        NSString *share_id = [responseObject valueForKey:@"share_id"];
        ShowHint(@"创建成功");
        HSLog(@"%s，创建分享成功，share_id = %@",__func__, share_id);
        _challenge_attend_share_id = share_id;
        [self associateShareToChallenge];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *error) {
        HSLog(@"%s %@",__func__, error);
        ShowHint(error);
        self.completeBtn.enabled = YES;
    }];
}

// 关联分享到挑战
- (void)associateShareToChallenge {
//    只关联一个挑战。可以不关联。  http://doc.live-forest.com/activity/#_26
    if (self.selectedChallenge == nil) return;
    
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge/%@/challenge_attend", [HSHttpRequestTool userToken], self.selectedChallenge.challenge_id];
    NSDictionary *para = @{@"challenge_attend_share_id": self.challenge_attend_share_id};
    
    [HSHttpRequestTool PUT:urlstr parameters:para success:^(id responseObject) {
        HSLog(@"%s,%@",__func__, @"关联分享到挑战 成功");
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

@end
