//
//  HSLoginViewController.m
//  LiveForest
//
//  Created by 傲男 on 16/1/22.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSLoginViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import "HSUserModelDAO.h"
#import "HSLoginByPhoneViewController.h"
#import "HSRegisterViewController.h"

#import "HSUserModelDAO.h"
#import "HSUserModel.h"

@interface HSLoginViewController ()

@end

@implementation HSLoginViewController

#pragma mark 载入界面
//- (void)loadView{

//    //屏幕适配
//    float factorWidth=[UIScreen mainScreen].bounds.size.width/self.view.frame.size.width;
//    float factorHeight=[UIScreen mainScreen].bounds.size.height/self.view.frame.size.height;
//    self.view.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
//    
//    //调整缩放后的位置
//    CGRect frame=self.view.frame;
//    frame.origin=CGPointZero;
//    self.view.frame=frame;
    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];  //?
    
    
    if (![WXApi isWXAppInstalled]) {
        //判断是否有微信,没有则隐藏
        self.btn_wechat.alpha = 0;
    }
    if(![WeiboSDK isWeiboAppInstalled]){
        //判断是否有微博，没有则隐藏
        self.btn_weibo.alpha = 0;
    }

    //设置navigationCtrl的代理
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //隐藏
    self.navigationController.navigationBar.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -微博登录
/**
 *  微博登录
 *
 *  @param sender sender button
 *
 */
- (IBAction)btnWeiboClick:(UIButton *)sender {
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                          if (result) {
                              id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
                              
                              NSString *uid = [[NSString alloc] initWithFormat:@"%@",[credential uid]];
                              
                              [HSUserModelDAO doLoginWithThridSource:@"1" andOpenId:uid andUserInfo:userInfo andRequestCB:^(NSString *userId) {
                                  //判断userId是否为空，为空则登录失败
                                  if(userId == nil){
                                      ShowHud(@"登录失败", NO);
                                  }else{
                                      //登录成功，跳转到主界面
                                      ShowHud(@"登录成功", NO);
                                      
                                      NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
                                  }
                              }];
                              
                              
                          } else {
                              HSLog(@"%s,%@",__func__, [error errorDescription]);
                              ShowHud([error errorDescription], NO);
                          }
                      }];
}
#pragma mark -微信登陆
/**
 *  微信登陆
 *
 *  @param sender 微信登陆
 */
- (IBAction)btnWechatClick:(UIButton *)sender {
    //调用第三方登录信息
    [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiTimeline];
            //提交微信资料
            NSString *uid = [[NSString alloc] initWithFormat:@"%@",[[[userInfo credential] extInfo] objectForKey:@"unionid"]];
            NSString *nickname = [[NSString alloc] initWithFormat:@"%@",[userInfo nickname]];
            NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
            
            //封装当前基本的用户信息
            NSMutableDictionary* userInfoDict = [[NSMutableDictionary alloc] init];
            
            //获取用户uid信息
            [userInfoDict setObject:[[[userInfo credential] extInfo] objectForKey:@"unionid"] forKey:@"openId"];
            
            //获取用户昵称
            [userInfoDict setObject:[userInfo nickname] forKey:@"nickname"];
            
            //获取用户头像
            [userInfoDict setObject:[userInfo profileImage] forKey:@"profileImage"];
            
            
            [HSUserModelDAO doLoginWithThridSource:@"0" andOpenId:uid andUserInfo:userInfo andRequestCB:^(NSString *userId) {
                //判断userId是否为空，为空则登录失败
                if(userId == nil){
                    ShowHud(@"登录失败", NO);
                }else{
                    
                    NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
                    
                    //登录成功，跳转到主界面
                    ShowHud(@"登录成功", NO);
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
                }
            }];
            
            
        }
    }];
}
/**
 *  手机注册按钮
 *
 *  @param sender sender button
 */
#pragma mark 注册响应事件
- (IBAction)btnRegisterClick:(UIButton *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    HSRegisterViewController *HSRegisterVC = (HSRegisterViewController *)[sb instantiateViewControllerWithIdentifier:@"HSRegisterViewController"];
    
    [self.navigationController pushViewController:HSRegisterVC animated:YES];
}
/**
 *  手机登陆按钮
 *
 *  @param sender sender button
 */
#pragma mark 响应登录事件
- (IBAction)btnLoginClick:(UIButton *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    HSLoginByPhoneViewController *HSLoginVC = (HSLoginByPhoneViewController *)[sb instantiateViewControllerWithIdentifier:@"HSLoginByPhoneViewController"];
    
    [self.navigationController pushViewController:HSLoginVC animated:YES];
}

#pragma mark 设置导航栏的代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //设置返回按钮
    
//    self.navigationController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"btn_chevron left_n"];
    
    //设置导航栏颜色为透明
    UIImage *image = [UIImage imageNamed:@"tran"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]];
    // 设置字体和颜色
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    dic[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    [self.navigationController.navigationBar setTitleTextAttributes:dic];

}

#pragma 返回按钮
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
