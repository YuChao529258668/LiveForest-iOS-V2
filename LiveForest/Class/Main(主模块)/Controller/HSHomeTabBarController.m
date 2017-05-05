//
//  HSHomeTabBarController.m
//  LiveForest
//
//  Created by 余超 on 15/11/25.
//  Copyright © 2015年 LiveForest. All rights reserved.
//


typedef NS_ENUM(NSInteger, HSViewController) {
    HSViewControllerYueBan = 0,
    HSViewControllerSports = 1,
    HSViewControllerShopping = 2,
    HSViewControllerMember = 3,
    HSViewControllerPersonal = 4
};

#import "HSHomeTabBarController.h"
#import "HSNavigationController.h"

//#import "UserProfileManager.h"
#import "HSNotificationTool.h"

@implementation HSHomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 发送登录成功的通知
    [HSNotificationTool postLoginSuccessNotification];
    
//    设置透明
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tran"]];
    
//    设置背景色
    self.tabBar.barTintColor = [UIColor colorWithRed:0x62/255.0 green:0x61/255.0 blue:0x61/255.0 alpha:1]; // 626161

    [self addChildViewControllerWithTag:HSViewControllerYueBan];
    [self addChildViewControllerWithTag:HSViewControllerSports];
    [self addChildViewControllerWithTag:HSViewControllerShopping];
//    [self addChildViewControllerWithTag:HSViewControllerMember]; // 去掉教练聊天模块
    [self addChildViewControllerWithTag:HSViewControllerPersonal];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    // 环信
//    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
//    [ChatDemoHelper shareHelper].mainVC = self.mainController;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        self.selectedIndex = 1;
//    });
}

- (void)addChildViewControllerWithTag:(HSViewController)controller {
    NSString *sbName;
    UIImage *imageSelected;
    UIImage *imageNormal;
    
    switch (controller) {
        case HSViewControllerYueBan:
            sbName = @"YueBan";
            imageSelected = [UIImage imageNamed:@"btn_yueban_h"];
            imageNormal = [UIImage imageNamed:@"btn_yueban_n"];
            break;
        case HSViewControllerSports:
            sbName = @"Sports";
            imageSelected = [UIImage imageNamed:@"btn_home_h"];
            imageNormal = [UIImage imageNamed:@"btn_home_n"];
            break;
        case HSViewControllerShopping:
            sbName = @"Shopping";
            imageSelected = [UIImage imageNamed:@"btn_shoppingcart_h"];
            imageNormal = [UIImage imageNamed:@"btn_shoppingcart_n"];
            break;
        case HSViewControllerPersonal:
            sbName = @"Personal";
            imageSelected = [UIImage imageNamed:@"btn_me_h"];
            imageNormal = [UIImage imageNamed:@"btn_me_n"];
            break;
        case HSViewControllerMember:
            sbName = @"Member";
            imageSelected = [UIImage imageNamed:@"btn_yueban_h"];
            imageNormal = [UIImage imageNamed:@"btn_yueban_n"];
            break;
    }
    imageNormal = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:imageNormal selectedImage:imageSelected];
    [tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -4, 0)]; // 设置图标居中

    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = sb.instantiateInitialViewController;
    vc.tabBarItem = tabBarItem;
    
    HSNavigationController *nav = [[HSNavigationController alloc]initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - UITabBarDelegate
// UITabBarController默认tabBar.delegate=self。而且不能修改tabBar.delegate，不然会报错
// self.tabBar.delegate = self; // Changing the delegate of a tab bar managed by a tab bar controller is not allow.
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //    每点击一次就会变大一次，所以要先清零。应该是iOS的bug。。。
    [item setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [item setImageInsets:UIEdgeInsetsMake(5, 0, -4, 0)];
}


#pragma mark - 接入环信聊天demo
- (void)addObserverForChar {
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
//    if (_chatListVC) {
//        if (unreadCount > 0) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
//    _connectionState = connectionState;
//    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
//    NSTimeInterval timeInterval = [[NSDate date]
//                                   timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        //如果距离上次响铃和震动时间太短, 则跳过响铃
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//        return;
//    }
//    
//    //保存最后一次响铃时间
//    self.lastPlaySoundDate = [NSDate date];
//    
//    // 收到消息时，播放音频
//    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
//    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
//    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
//    //发送本地推送
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate date]; //触发通知的时间
//    
//    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
//        EMMessageBody *messageBody = message.body;
//        NSString *messageStr = nil;
//        switch (messageBody.type) {
//            case EMMessageBodyTypeText:
//            {
//                messageStr = ((EMTextMessageBody *)messageBody).text;
//            }
//                break;
//            case EMMessageBodyTypeImage:
//            {
//                messageStr = NSLocalizedString(@"message.image", @"Image");
//            }
//                break;
//            case EMMessageBodyTypeLocation:
//            {
//                messageStr = NSLocalizedString(@"message.location", @"Location");
//            }
//                break;
//            case EMMessageBodyTypeVoice:
//            {
//                messageStr = NSLocalizedString(@"message.voice", @"Voice");
//            }
//                break;
//            case EMMessageBodyTypeVideo:{
//                messageStr = NSLocalizedString(@"message.video", @"Video");
//            }
//                break;
//            default:
//                break;
//        }
//        
//        do {
//            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
//            if (message.chatType == EMChatTypeGroupChat) {
//                NSDictionary *ext = message.ext;
//                if (ext && ext[kGroupMessageAtList]) {
//                    id target = ext[kGroupMessageAtList];
//                    if ([target isKindOfClass:[NSString class]]) {
//                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                    else if ([target isKindOfClass:[NSArray class]]) {
//                        NSArray *atTargets = (NSArray*)target;
//                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
//                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                }
//                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:message.conversationId]) {
//                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
//                        break;
//                    }
//                }
//            }
//            else if (message.chatType == EMChatTypeChatRoom)
//            {
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
//                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
//                if (chatroomName)
//                {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
//                }
//            }
//            
//            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
//        } while (0);
//    }
//    else{
//        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
//    }
//    
//#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
//    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
//    
//    notification.alertAction = NSLocalizedString(@"open", @"Open");
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//    } else {
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        self.lastPlaySoundDate = [NSDate date];
//    }
//    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
//    [userInfo setObject:message.conversationId forKey:kConversationChatter];
//    notification.userInfo = userInfo;
//    
//    //发送通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    //    UIApplication *application = [UIApplication sharedApplication];
//    //    application.applicationIconBadgeNumber += 1;
}


@end
