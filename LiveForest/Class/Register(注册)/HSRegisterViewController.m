//
//  HSRegisterViewController.m
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSRegisterViewController.h"
#import "HSCountDownButton.h"
#import "HSRegisterDAO.h"
#import "HSDataFormatHandle.h"
#import "HSCompletePersonalInfoViewController.h"
#import "HSUserModelDAO.h"
#import "HSUserModel.h"

#import "AppDelegate.h"

@interface HSRegisterViewController ()

@property (weak, nonatomic) IBOutlet HSCountDownButton *btnGetCheckNum;
@end

@implementation HSRegisterViewController

#pragma mark - Setup
- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTap];
    
    self.tfPhoneNumber.delegate = self;
    self.tfPassword.delegate = self;
    self.tfCheckNum.delegate = self;
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"btn_chevron left_n"];
    
    [self.navigationItem setTitle:@"手机号注册"];
    [UINavigationBar setAttributesWithTarget:self.navigationController TextColor:[UIColor whiteColor] FontOfSize:20];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 ** 获取验证码
 @pragram  HSCountDownButton
 @result
 */
- (IBAction)btnGetCheckNumClick:(HSCountDownButton *)sender {
    
    //关闭键盘
    [self closeKeyboard:sender];
    
    //判断输入的手机号码格式
    if (![HSDataFormatHandle checkPhoneNumber:self.tfPhoneNumber.text]) {
        ShowHud(@"手机号格式错误", NO);
        return;
    }
    
    //请求验证码
    sender.enabled = NO;
    
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:30];
    
    [sender didChange:^NSString *(HSCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"重新获取(%d)",second];
        return title;
    }];
    [sender didFinished:^NSString *(HSCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"获取验证码";
    }];
    
    /*请求网络验证码*/
    [HSRegisterDAO getCheckNum:self.tfPhoneNumber.text andCallBack:^(bool success, NSString *error) {
        if(success){
            ShowHud(@"发送验证码成功！", NO);
        }
        else{
            ShowHud(error, NO);
        }
    }];
    
}
/*
 ** 提交注册
 @pragram
 @result
 */
#pragma mark 注册提交
- (IBAction)btnRegisterClick:(UIButton *)sender {
    
    [HSUserModel saveLastPhoneNumber:self.tfPhoneNumber.text password:self.tfPassword.text];

    
    //菊花加载
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在注册";
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    [HSRegisterDAO registerPhone:self.tfPhoneNumber.text andPassword:self.tfPassword.text andCheckNum:self.tfCheckNum.text andCallBack:^(bool success, NSString *error) {
        if(success){
            
            [hud hide:YES];
            ShowHud(@"注册成功！", NO);
            
            AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
            ad.isNewUser = YES;
            
            
            //手机密码自动登录
            //构造请求数据
            [HSUserModelDAO doLoginWithUserPhone:self.tfPhoneNumber.text andUserLoginPassword:self.tfPassword.text andRequestCB:^(NSString *userId) {
                if(userId == nil){
                    //如果用户ID为空，即登录失败
//                    ShowHud(@"登录失败", NO);
//                    self.tfPassword.text = @"";
                    HSLog(@"登录失败");
                }else{
                    //后台登陆，保存用户信息
                    
                    //跳转
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                    
                    HSCompletePersonalInfoViewController *completePersonalInfoVC = (HSCompletePersonalInfoViewController *)[sb instantiateViewControllerWithIdentifier:@"HSCompletePersonalInfoViewController"];
                    [self.navigationController pushViewController:completePersonalInfoVC animated:YES];
                    
                    self.navigationController.navigationBar.userInteractionEnabled = YES;

                }
            }];
            
                    }else{
            
            [hud hide:YES];
            ShowHud(@"注册失败！", NO);
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }
    }];
    
}
#pragma mark 返回按钮
- (void)backClick{
    
    //如果用户token已经存在，则直接登录进入主界面
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"]){
//        
//        NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
////        //登录成功，跳转到成功页面
//        [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
//    }
//    else{
//        
        [self.navigationController popViewControllerAnimated:YES];
//
//    }
}

//关闭键盘
- (void)closeKeyboard:(id)sender {
    if([self.tfPhoneNumber isFirstResponder])
        [self.tfPhoneNumber resignFirstResponder];
    else if([self.tfPassword isFirstResponder])
        [self.tfPassword resignFirstResponder];
    else if(self.tfCheckNum){
        [self.tfCheckNum resignFirstResponder];
    }
    
    //    [self.view endEditing:YES];
}
#pragma 关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    

    return YES;
}

#pragma mark 监听各个textfield状态
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([HSDataFormatHandle checkPhoneNumber:self.tfPhoneNumber.text] && self.tfPassword.text.length>0 && self.tfCheckNum.text.length==4){
        [self.btnNextStep setImage:[UIImage imageNamed:@"btn_nextgreen_n"] forState:UIControlStateNormal];
        [self.btnNextStep setUserInteractionEnabled:YES];
    }
    else{
        [self.btnNextStep setImage:[UIImage imageNamed:@"btn_next_n"] forState:UIControlStateNormal];
        [self.btnNextStep setUserInteractionEnabled:NO];
    }
}

#pragma mark 界面将要出现时处理
- (void)viewWillAppear:(BOOL)animated{
    self.tfCheckNum.text = @"";
    self.tfPhoneNumber.text = @"";
    self.tfPassword.text = @"";
    [self.btnNextStep setUserInteractionEnabled:NO];
    [self.btnNextStep setImage:[UIImage imageNamed:@"btn_next_n"] forState:UIControlStateNormal];
}

#pragma mark 界面出现后
- (void)viewDidAppear:(BOOL)animated{
    //测试：直接跳转到信息补全页
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"ws2FvcrkbGaO0UL5e2BgkXAIRrP2BQYCxSYVdIeD6eFrXo3D" forKey:@"user_token"];
//    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
//    
//    HSCompletePersonalInfoViewController *completePersonalInfoVC = (HSCompletePersonalInfoViewController *)[sb instantiateViewControllerWithIdentifier:@"HSCompletePersonalInfoViewController"];
//    [self.navigationController pushViewController:completePersonalInfoVC animated:YES];
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
