//
//  HSCreateChallengeController.m
//  LiveForest
//
//  Created by 余超 on 15/12/14.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSCreateChallengeController.h"
#import "YCDatePickerController.h"
#import "HSSelectedFriendController.h"

#import "HSFriend.h"
#import "HSUserModel.h"

#import "YCDropdownMenu.h"
//#import "YCDatePicker.h"

#import "UIViewController+HSShow.h"
#import "HSHttpRequestTool.h"


@interface HSCreateChallengeController ()
@property (nonatomic, strong) NSMutableArray *friends;
@end


@implementation HSCreateChallengeController

#pragma mark - Initial
- (instancetype)init {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YueBan" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"HSCreateChallengeController"];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/// 屏幕适配
- (void)shipei {
    // 子控件太多，屏幕太小，只能缩放了。
    // 为什么 self.view.frame.size.width = 320 ??
    // 缩放之后，为什么不用调整 origin 呢？？
    // 在故事板的宽度是 375
    float scale = [UIScreen mainScreen].bounds.size.width / 375;
    self.view.transform = CGAffineTransformMakeScale(scale, scale);
}


#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMaskBtn];
    [self setupScoreMenu];
    [self setupNotifications];
    
    [self shipei];
}

#pragma mark - Setup
- (void)setupMaskBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:self.view.frame];
    [btn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view sendSubviewToBack:btn];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupScoreMenu {
    NSArray *scores = @[@"无",@"10积分",@"20积分",@"50积分"];
    float tableViewRowHeight = 48;
    float tableViewHeight = 2.5 * tableViewRowHeight;
    
    self.scoreMenu = [YCDropdownMenu menuWithFrame:self.scoreTF.bounds tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择积分"];
    self.scoreMenu.titles = scores;
//    [self.view addSubview:self.scoreMenu];
    [self.scoreTF addSubview:self.scoreMenu];
    
//    [self.scoreTF removeFromSuperview];
    self.scoreTF.placeholder = @"";
    self.scoreTF.userInteractionEnabled = YES;
}

#pragma mark - Actions
- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self hs_dismissViewController];
    }
}

- (IBAction)selectDateBtnClick:(UIButton *)btn {
    YCDatePickerController *vc = [YCDatePickerController new];
    __weak YCDatePickerController *weakVC = vc;
    
    vc.completeBlock = ^(NSDate *date){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM月dd日HH:mm";
        NSString *dateS = [formatter stringFromDate:date];
        
        [btn setTitle:dateS forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
//        [weakVC hs_dismissViewController];
        [weakVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.cancelBlock = ^{
//        [weakVC hs_dismissViewController];
        [weakVC dismissViewControllerAnimated:YES completion:nil];
    };
    
//    [self hs_showViewController:vc];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}

// 发布挑战
- (IBAction)publishBtnClick:(UIButton *)sender {
    //    获取值
    NSArray *challenge_user_id_invited = [self friendIDs];
    NSArray *challenge_outer_users = @[self.friendTF.text];
    NSString *challenge_content = self.contentTF.text;
    NSString *challenge_deadline = self.selectDateBtn.currentTitle;
    NSString *score = self.scoreMenu.titleLabel.text;  //challenge_reward_credit 积分
    NSString *challenge_reward_text = self.rewardTF.text;
    NSString *challenge_text_info = self.messageTF.text;
    NSString *challenge_city_id = [NSString stringWithFormat:@"%@", [HSUserModel currentUser].user_city];
    
    if ([challenge_content isEqualToString:@""] || [challenge_deadline isEqualToString:@"选择时间"] || [score isEqualToString:@"选择积分"] || [challenge_reward_text isEqualToString:@""]) {
        ShowHint(@"信息不全");
        return;
    }
    
    //    有效时间换成时间戳，02月01日10:56。字符串转NSDate然后转秒数。
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *year = [NSString stringWithFormat:@"%ld年", (long)components.year];
    challenge_deadline = [year stringByAppendingString:challenge_deadline]; // 用户选择的时间只有日月，要手动加上年份。
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY年MM月dd日HH:mm";
    NSDate *date = [formatter dateFromString:challenge_deadline]; // 字符串转NSADate
    challenge_deadline = [NSString stringWithFormat:@"%f",date.timeIntervalSince1970]; // 秒数转字符串
    
    //    去掉积分两字
    if ([score isEqualToString:@"无"]) {
        score = @"0";
    } else {
        score = [score substringToIndex:score.length - @"积分".length];
    }
    
    NSMutableDictionary *requestData = @{}.mutableCopy;
    requestData[@"challenge_user_id_invited"] = challenge_user_id_invited;
    requestData[@"challenge_outer_users"] = challenge_outer_users;
    requestData[@"challenge_content"] = challenge_content;
    requestData[@"challenge_deadline"] = challenge_deadline;
    requestData[@"challenge_reward_credit"] = score;
    requestData[@"challenge_reward_text"] = challenge_reward_text;
    requestData[@"challenge_text_info"] = challenge_text_info;
    requestData[@"challenge_city_id"] = challenge_city_id;
    
    NSString *urlstr =  [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/challenge", [HSHttpRequestTool userToken]];
    
    [HSHttpRequestTool POST:urlstr parameters:requestData success:^(id responseObject) {
        NSString *challenge_id = [responseObject valueForKey:@"challenge_id"];
        HSLog(@"%s, 创建挑战成功，challenge_id = %@", __func__, challenge_id);
        ShowHint(@"创建成功");
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
        ShowHint(error);
    }];

}

- (IBAction)selectFriendBtnClick:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSSelectedFriendController *vc = [sb instantiateViewControllerWithIdentifier:@"HSSelectedFriendController"];
    
    vc.selectedFriends = self.friends;
    vc.completeBlock = ^(NSArray *friends){
        self.friends = [friends copy];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Helper
//  获取邀请好友的ID。
- (NSArray *)friendIDs {
    NSMutableArray *ids = [NSMutableArray new];
    for (HSFriend *friend in self.friends) {
        [ids addObject:friend.user_id];
    }
    return ids;
}

//- (void)keyboardWillShow:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
//    NSValue *frame = userInfo[UIKeyboardFrameEndUserInfoKey];
//    float keyboardHeight = frame.CGRectValue.size.height;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.origin = CGPointMake(0, -keyboardHeight);
//    }];
//    
//    [self setMenusEnable:NO];
//}
- (void)keyboardWillShow:(NSNotification *)notification {
    if ([self.rewardTF isFirstResponder] || [self.messageTF isFirstResponder] || [self.contentTF isFirstResponder]) {
        
        NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
        NSValue *frame = userInfo[UIKeyboardFrameEndUserInfoKey];
        float keyboardHeight = frame.CGRectValue.size.height;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.view.origin = CGPointMake(0, -keyboardHeight);
        }];
    }
    
    if ([self.friendTF isFirstResponder]) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.origin = CGPointMake(0, 0);
        }];
    }
    
    [self setMenusEnable:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.origin = CGPointMake(0, 0);
    }];
    
    [self setMenusEnable:YES];
}

- (IBAction)closeKeyboard {
    [self.view endEditing:YES];
}

- (void)setMenusEnable:(BOOL)userInteractionEnabled {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[YCDropdownMenu class]]) {
            view.userInteractionEnabled = userInteractionEnabled;
        }
    }
}

@end
