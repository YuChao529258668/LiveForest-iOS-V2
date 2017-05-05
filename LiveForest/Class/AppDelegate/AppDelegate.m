//
//  AppDelegate.m
//  LiveForest
//
//  Created by 余超 on 15/11/25.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "AppDelegate.h"

#import "UMessage.h"
#import <ShareSDK/ShareSDK.h>
#import <BmobSDK/Bmob.h>
#import "Reachability.h"

#import "ServiceHeader.h"

#import "HSLoginLogic.h"
#import "HSLoginViewController.h"
#import "HSHomeTabBarController.h"

#import "HSUserModelDAO.h"
#import "HSUserModel.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 环信
#import "AppDelegate+EaseMob.h"
#import "AppDelegate+Parse.h"
#import "RedPacketUserConfig.h"
#import "AlipaySDK.h"


@interface AppDelegate ()

@property (nonatomic, strong) NSString *pushMessageLanuchApp; //作为判断是否是推送唤起了应用
@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) UINavigationController *navigationCtrl;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.isNewUser = NO;
    
    
    //初始化第三方组件
    [self initConfig:launchOptions];

    
    //记录  判断是否是推送唤起了应用  changed by qiang
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pushMessageLanuchApp"];
    _pushMessageLanuchApp = [[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"];
    if(_pushMessageLanuchApp){
        [[NSUserDefaults standardUserDefaults] setObject:_pushMessageLanuchApp forKey:@"pushMessageLanuchApp"];
    }
    
    
    //记录应用是否第一次 启动
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"appFinishedLanunch"];
    
    
    // 监测网络情况,如果没联网，并且有缓存，则直接进入应用；如果没有缓存，进入登陆界面；如果从断网联网了，那么通知各个模块，重新加载数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReach startNotifier];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //测试代码，使用默认的user_token
    [userDefaults setObject:@"9sz9UP9bo4VM7I1zdXoPrk2FHnJShMGuSwadv9D2BUVhs3D" forKey:@"user_token"];
    //测试阶段，先删除usertoken 自动登录
//    [userDefaults removeObjectForKey:@"user_token"];
//    [userDefaults synchronize];
    
    
    //判断是否进入登陆注册还是跳转到主界面,并根据网络状态判断
    if ([[userDefaults objectForKey:@"user_token"] length] > 0) {
        //如果没网络，则直接进入应用，否则，需要进行判断
        if(NotReachable == self.hostReach.currentReachabilityStatus) {
            //不是登陆注册
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HSHomeTabBarController *hSHomeTabBarControlelr = [sb instantiateInitialViewController];
            self.window.rootViewController = hSHomeTabBarControlelr;
        }
        else{
            [HSLoginLogic isLogin:false andCallBack:^(Boolean isLogin) {
                if(isLogin){
                    //进入主界面
                    NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
                    //登录成功，跳转到成功页面
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
                }
                else{
                    // 用于演示，暂时取消返回登录界面
                    
//                    //未登录或者过期
//                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                    HSLoginViewController *HSLoginVC = (HSLoginViewController *)[sb instantiateViewControllerWithIdentifier:@"HSLoginViewController"];
//                    self.navigationCtrl = [[UINavigationController alloc] initWithRootViewController:HSLoginVC];
//                    self.window.rootViewController = self.navigationCtrl;
                }
            }];
        }
    }
    else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        HSLoginViewController *HSLoginVC = [sb instantiateViewControllerWithIdentifier:@"HSLoginViewController"];
        self.navigationCtrl = [[UINavigationController alloc] initWithRootViewController:HSLoginVC];
        self.window.rootViewController = self.navigationCtrl;
    }
    
    
    // 环信聊天
    [self huanXinConfigWithApp:application WithOptions:launchOptions];
    // Bmob后端云
    [self setupBmob];
  
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - Inner Help

- (void)changeRootViewController:(NSNotification *)nSNotification{
    NSDictionary* userInfo =  nSNotification.userInfo;
    
    if([[userInfo objectForKey:@"rootViewControllerName"] isEqualToString:@"HSHomeTabBarController"]){
        //菊花加载
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"正在更新";
        
        [HSUserModelDAO getUserInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] orUserToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"] andRequestCB:^(HSUserModel *user) {
            //判断是否为空，如果为空直接跳转
            if(user == NULL){//
                HSLog(@"请求个人信息错误");
                ShowHud(@"请求个人信息失败",NO);
            }
            else{
                HSLog(@"请求个人信息成功");
                [HSUserModel setCurrentUser:user];
                //如果是要跳转到登录控制器
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HSHomeTabBarController *hSHomeTabBarControlelr = [sb instantiateInitialViewController];
                self.window.rootViewController = hSHomeTabBarControlelr;
            }
            [hud hide:YES];
        }];
    }
}

#pragma mark 初始化所有第三方东西
- (void)initConfig:(NSDictionary *)launchOptions{
    
    NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
    
    //注册AppDelegate的监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeRootViewController:)
                                                 name: notificatioName
                                               object: nil];
    
    //初始化友盟反馈以及蒲公英
    [HSUMengService initService];
    
    //初始化友盟推送，只能放在这边
    [self initUMessage:launchOptions];
    
    //初始化百度地图
    [HSBaiduMapService initService];
    
    //初始化ShareSDK
    [HSShareSDKService initService];
    
    //初始化TuSDK
    [HSTuSDKService initService];
}

#pragma mark 友盟推送
- (void) initUMessage:(NSDictionary *)launchOptions{
    //必须先导入推送文件
    //    如果确实是第一次安装运行且没有弹出，请仔细按照证书配置的要求重新生成一遍Provisioning Profiles。
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"5585756667e58e2827000e24" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}

#pragma mark 收到远程推送
// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 这是环信的
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    

    NSData *data = [deviceToken copy];
    HSLog(@"%@:%@",deviceToken,data);

    //获取TokenID
    NSString *tokenID = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""] ;

    NSLog(@"tokenID:%@",tokenID);

    //将设备ID存入本地缓存
    [[NSUserDefaults standardUserDefaults] setObject:tokenID forKey:@"UMtokenId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //注册该设备
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //将接收到的消息交付给PushService处理
    [HSPushService handleUserInfo:userInfo];
    
    //告诉友盟我收到了消息
    [UMessage didReceiveRemoteNotification:userInfo];
}

#pragma mark 监测网络状态
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LiveForest"
                                                        message:@"请检查网络连接!"
                                                       delegate:nil
                                              cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];
    }
    else{
        //        通知各个模块重新加载数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSReloadData" object:nil];
    }
}

#pragma mark - 环信
- (void)huanXinConfigWithApp:(UIApplication *)application WithOptions:(NSDictionary *)launchOptions {
    NSString *EaseMobAppKey = @"529258668#liveforest";
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
//#warning 环信的apnsCertName
    options.apnsCertName = @"LF-push-dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    // demo的代码
#ifdef REDPACKET_AVALABLE
    /**
     *  TODO: 通过环信的AppKey注册红包
     */
    [[RedPacketUserConfig sharedConfig] configWithAppKey: EaseMobAppKey];
#endif
//    _connectionState = EMConnectionConnected;

    
    // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
    
#warning 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
//#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
//    NSString *apnsCertName = nil;
//#if DEBUG
//    apnsCertName = @"chatdemoui_dev";
//#else
//    apnsCertName = @"chatdemoui";
//#endif
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    
    NSString *apnsCertName = @"LF-push-dev";
    appkey = @"co.hoteam.lf";
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    // 文档
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"appkey" apnsCertName:apnsCertName];

    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }

}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
//                                                    message:error.description
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//#warning 环信apns弹窗
//    [alert show];
}


#pragma mark - Bmob 后台

- (void)setupBmob {
    [Bmob registerWithAppKey:@"c92a7946ff978a5c4cb1f109a9eac0ca"];
}



@end
