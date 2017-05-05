//
//  HSLoginByPhoneViewController.m
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSLoginByPhoneViewController.h"
#import "HSDataFormatHandle.h"
#import "HSUserModelDAO.h"
#import "HSUserModel.h"

@implementation HSLoginByPhoneViewController

#pragma mark - Setup
- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTap];
    
    self.tfPhoneNumber.text = [HSUserModel lastPhoneNumber];
    self.tfPassword.text = [HSUserModel lastPassword];
    
    self.tfPhoneNumber.delegate = self;
    self.tfPassword.delegate = self;
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"btn_chevron left_n"];
    
    [self.navigationItem setTitle:@"手机号登录"];
    [UINavigationBar setAttributesWithTarget:self.navigationController TextColor:[UIColor whiteColor] FontOfSize:20];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginClick:(UIButton *)sender {
    //判断账户名是否为空
//    if (![HSDataFormatHandle checkPhoneNumber:self.tfPhoneNumber.text]) {
//        ShowHud(@"手机格式有误！", NO);
//        return;
//    }
    
    //判断密码是否为空
    if (self.tfPassword.text == nil || self.tfPassword.text.length == 0 || [[self.tfPassword.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        ShowHud(@"密码不能为空", NO);
        return ;
    }
    
    
    [HSUserModel saveLastPhoneNumber:self.tfPhoneNumber.text password:self.tfPassword.text];

    
    //发起网络请求，账号&密码登陆
    [self postRequestComplete];
}


#pragma mark - 请求数据，并处理
/**
 *  请求数据，并在回调函数（代码块中）处理
 */
- (void)postRequestComplete
{
    //菊花加载
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在登陆";
    
    //销毁键盘
    [self.tfPhoneNumber resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    
    
    
    //构造请求数据
    [HSUserModelDAO doLoginWithUserPhone:self.tfPhoneNumber.text andUserLoginPassword:self.tfPassword.text andRequestCB:^(NSString *userId) {
        if(userId == nil){
            //如果用户ID为空，即登录失败
            ShowHud(@"登录失败", NO);
//            self.tfPassword.text = @"";
        }else{
            
            NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
            
            //登录成功，跳转到成功页面
            [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
        }
    }];
}

//关闭键盘
- (void)closeKeyboard:(id)sender {
        if([self.tfPhoneNumber isFirstResponder])
            [self.tfPhoneNumber resignFirstResponder];
        else if([self.tfPassword isFirstResponder])
            [self.tfPassword resignFirstResponder];
    
//    [self.view endEditing:YES];
}
#pragma 关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    //判断是否是密码键盘
//    if(textField == self.tfPassword){
//        [self readyLogin];
//    }
    
    
    return YES;
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
