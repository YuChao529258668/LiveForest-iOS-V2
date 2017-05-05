//
//  HSCreateYueBanController.m
//  LiveForest
//
//  Created by 余超 on 15/12/14.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSCreateYueBanController.h"
#import "YCDropdownMenu.h"
#import "HSHttpRequestTool.h"

@interface HSCreateYueBanController ()
@end

@implementation HSCreateYueBanController

#pragma mark - Initial
- (instancetype)init {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YueBan" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"HSCreateYueBanController"];
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
    [self setupMenus];
    [self setupNotifications];
//    [self setupBackGroundImage];
    
    [self shipei];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"%s",__func__);
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"%s",__func__);
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    //    [self setupBackGroundImage];
//    NSLog(@"%s",__func__);
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"%s",__func__);
//    
//}


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

- (void)setupMenus {
    NSArray *friends = @[@"仅发送给好友",@"发送给所有人"];
    float tableViewRowHeight = 48;
    float tableViewHeight = friends.count * tableViewRowHeight;
    
    self.friendMenu = [YCDropdownMenu menuWithFrame:self.friendTF.bounds tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择好友类型"];
    self.friendMenu.titles = friends;
    //    [self.view addSubview:self.friendMenu];
    [self.friendTF addSubview:self.friendMenu];
    
    
//    NSArray *times = @[@"1小时有效",@"2小时有效",@"12小时有效",@"自定约伴信息时效"];
    NSArray *times = @[@"1小时有效",@"2小时有效",@"12小时有效"];
    tableViewHeight = times.count * tableViewRowHeight;
    
    self.timeMenu = [YCDropdownMenu menuWithFrame:self.timeTF.bounds tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择有效时长"];
    self.timeMenu.titles = times;
    //    [self.view addSubview:self.timeMenu];
    [self.timeTF addSubview:self.timeMenu];
    
    
    NSArray *scores = @[@"无",@"10积分",@"20积分",@"50积分"];
    tableViewHeight = 2.5 * tableViewRowHeight;
    
    self.scoreMenu = [YCDropdownMenu menuWithFrame:self.scoreTF.bounds tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择积分"];
    self.scoreMenu.titles = scores;
    //    [self.view addSubview:self.scoreMenu];
    [self.scoreTF addSubview:self.scoreMenu];
    
    self.friendTF.userInteractionEnabled = YES;
    self.timeTF.userInteractionEnabled = YES;
    self.scoreTF.userInteractionEnabled = YES;
    self.friendTF.placeholder = @"";
    self.timeTF.placeholder = @"";
    self.scoreTF.placeholder = @"";
}

// 适配前。
- (void)setupMenus0 {
    NSArray *friends = @[@"仅发送给好友",@"发送给所有人"];
    float tableViewRowHeight = 48;
    float tableViewHeight = friends.count * tableViewRowHeight;
    
    self.friendMenu = [YCDropdownMenu menuWithFrame:self.friendTF.frame tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择好友类型"];
    self.friendMenu.titles = friends;
    [self.view addSubview:self.friendMenu];
    
    
//    NSArray *times = @[@"1小时有效",@"2小时有效",@"12小时有效",@"自定约伴信息时效"];
    NSArray *times = @[@"1小时有效",@"2小时有效",@"12小时有效"];
    tableViewHeight = times.count * tableViewRowHeight;
    
    self.timeMenu = [YCDropdownMenu menuWithFrame:self.timeTF.frame tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择有效时长"];
    self.timeMenu.titles = times;
    [self.view addSubview:self.timeMenu];
    
    
    NSArray *scores = @[@"无",@"10积分",@"20积分",@"50积分"];
    tableViewHeight = 2.5 * tableViewRowHeight;
    
    self.scoreMenu = [YCDropdownMenu menuWithFrame:self.scoreTF.frame tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择积分"];
    self.scoreMenu.titles = scores;
    [self.view addSubview:self.scoreMenu];
    
    
    [self.friendTF removeFromSuperview];
    [self.timeTF removeFromSuperview];
    [self.scoreTF removeFromSuperview];
}

//- (void)setupMenus {
//    NSArray *friends = @[@"仅发送给好友",@"发送给所有人"];
//    float tableViewRowHeight = 48;
//    float tableViewHeight = friends.count * tableViewRowHeight;
//    
//    self.friendMenu = [YCDropdownMenu menuWithFrame:self.friendTF.frame tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择好友类型"];
//    self.friendMenu.titles = friends;
//    [self.view addSubview:self.friendMenu];
//    
//    
//    NSArray *times = @[@"1小时有效",@"2小时有效",@"12小时有效",@"自定约伴信息时效"];
//    NSArray *times = @[@"1小时有效",@"2小时有效",@"12小时有效"];

//    tableViewHeight = times.count * tableViewRowHeight;
//    
//    self.timeMenu = [YCDropdownMenu menuWithFrame:self.timeTF.frame tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择有效时长"];
//    self.timeMenu.titles = times;
//    [self.view addSubview:self.timeMenu];
//    
//    
//    NSArray *scores = @[@"无",@"10积分",@"20积分",@"50积分"];
//    tableViewHeight = 2.5 * tableViewRowHeight;
//    
//    self.scoreMenu = [YCDropdownMenu menuWithFrame:self.scoreTF.frame tableViewRowHeight:tableViewRowHeight tableViewHeight:tableViewHeight title:@"选择积分"];
//    self.scoreMenu.titles = scores;
//    [self.view addSubview:self.scoreMenu];
//    
//    
////    [self.friendTF removeFromSuperview];
////    [self.timeTF removeFromSuperview];
////    [self.scoreTF removeFromSuperview];
//    self.friendTF.hidden = YES;
//    self.timeTF.hidden = YES;
//    self.scoreTF.hidden = YES;
//}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    self.friendMenu.frame = self.friendTF.frame;
//    self.timeMenu.frame = self.timeTF.frame;
//    self.scoreMenu.frame = self.scoreTF.frame;
//}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.friendMenu.frame = self.friendTF.frame;
//        self.timeMenu.frame = self.timeTF.frame;
//        self.scoreMenu.frame = self.scoreTF.frame;
////        self.scoreMenu.center = CGPointMake(100, 100);
//    });
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    self.friendMenu.frame = self.friendTF.frame;
//    self.timeMenu.frame = self.timeTF.frame;
//    self.scoreMenu.frame = self.scoreTF.frame;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.friendMenu.frame = self.friendTF.frame;
//        self.timeMenu.frame = self.timeTF.frame;
//        self.scoreMenu.frame = self.scoreTF.frame;
//    });
//
//}

- (void)setupBackGroundImage {
//    NSLog(@"%@,%@,%@",self.presentingViewController,self.presentedViewController,self.modalViewController);
    UIViewController *vc = self.presentingViewController;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    vc = window.rootViewController;
    UIGraphicsBeginImageContext(vc.view.frame.size);
    [vc.view drawViewHierarchyInRect:vc.view.frame afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *iv = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:iv];
    [self.view sendSubviewToBack:iv];
}

#pragma mark - Actions
- (void)keyboardWillShow:(NSNotification *)notification {
//    NSLog(@"%@",notification);
//    {name = UIKeyboardWillShowNotification; userInfo = {
//        UIKeyboardFrameBeginUserInfoKey = NSRect: {{0, 409}, {375, 258}},
//        UIKeyboardCenterEndUserInfoKey = NSPoint: {187.5, 554.5},
//        UIKeyboardBoundsUserInfoKey = NSRect: {{0, 0}, {375, 225}},
//        UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 442}, {375, 225}},
//        UIKeyboardAnimationDurationUserInfoKey = 0,
//        UIKeyboardCenterBeginUserInfoKey = NSPoint: {187.5, 538},
//        UIKeyboardAnimationCurveUserInfoKey = 7,
//        UIKeyboardIsLocalUserInfoKey = 1
//    }}
    
    if ([self.rewardTF isFirstResponder] || [self.messageTF isFirstResponder]) {
        
        NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
        NSValue *frame = userInfo[UIKeyboardFrameEndUserInfoKey];
        float keyboardHeight = frame.CGRectValue.size.height;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.view.origin = CGPointMake(0, -keyboardHeight);
        }];
    }
    
    if ([self.contentTF isFirstResponder]) {
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

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        CGRect f = self.view.frame;
        f.origin.y = CGRectGetMaxY([UIScreen mainScreen].bounds);
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.frame = f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}

// 发布约伴
- (IBAction)publishBtnClick:(UIButton *)sender {
//   h ttp://121.41.104.156:10086/Social/YueBan/doYueBanCreateByUser?requestData={"user_token":"qnZ5awrOszYd1iFb3iLF9OOkJtixiaWs2FXALWBkE42FA3D","yueban_sport_id":"1","yueban_text_info":"下午6点南操场打篮球","yueban_voice_info":"http://xx/xx.xx","yueban_user_city":"1","yueban_recommend_type":"1"}
    
    NSString *yueban_text_info = self.contentTF.text;
//    NSString *yueban_voice_info;
//    NSString *yueban_voice_second;
//    NSString *yueban_user_city;
    NSString *yueban_recommend_type = self.friendMenu.titleLabel.text;// "1":邀请所有用户，现在就是随机20个用户，以后按照城市和运动类型筛选,"0":邀请我的好友，互粉的人
//    NSString *yueban_sport_id;
//    NSString *user_sport;
    NSString *estimated_time = self.timeMenu.titleLabel.text;
    NSString *score = self.scoreMenu.titleLabel.text;
    NSString *reward = self.rewardTF.text;
    
//    业务逻辑处理
    if ([yueban_recommend_type isEqualToString:@"仅发送给好友"]) {
        yueban_recommend_type = @"0";
    } else {
        yueban_recommend_type = @"1";
    }
//    有效时间换成时间戳
    estimated_time = [estimated_time substringToIndex:estimated_time.length - @"小时有效".length];
    NSDate *estimatedDate = [[NSDate alloc]initWithTimeIntervalSinceNow:estimated_time.intValue *3600];
    estimated_time = [NSString stringWithFormat:@"%f",estimatedDate.timeIntervalSince1970];
//    去掉积分两字，比如20积分
    if ([score isEqualToString:@"无"]) {
        score = @"0";
    } else {
        score = [score substringToIndex:score.length - @"积分".length];
    }
    
    NSMutableDictionary *requestData = @{}.mutableCopy;
    requestData[@"user_token"] = [HSHttpRequestTool userToken];
    requestData[@"yueban_text_info"] = yueban_text_info;
    requestData[@"yueban_recommend_type"] = yueban_recommend_type;
    requestData[@"estimated_time"] = estimated_time;
    requestData[@"score"] = score;
    requestData[@"reward"] = reward;
//    requestData[@"yueban_sport_id"] = yueban_sport_id;
//    requestData[@"yueban_user_city"] = yueban_user_city;
    
    NSString *urlstr = @"http://api.liveforest.com/Social/YueBan/doYueBanCreateByUser";
    
    [HSHttpRequestTool POST:urlstr parameters:requestData success:^(id responseObject) {
        ShowHint(@"创建成功");
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
        ShowHint(error);
    }];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController addChildViewController:self];
    [window addSubview:self.view];
    [window insertSubview:self.view belowSubview:self.navigationController.navigationBar];
    
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect f = self.view.frame;
    f.origin.y = bounds.size.height;
    self.view.frame = f;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = bounds;
    } completion:nil];
}

- (void)showFromController:(UIViewController *)controller {
    
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect f = self.view.frame;
    f.origin.y = bounds.size.height;
    self.view.frame = f;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = bounds;
    } completion:nil];
}

- (void)showFromController:(UIViewController *)controller didShowBlock:(void(^)())show {
    
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect f = self.view.frame;
    f.origin.y = bounds.size.height;
    self.view.frame = f;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = bounds;
    } completion:nil];
    
}

@end
