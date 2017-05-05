//
//  HSCompletePersonalInfoViewController.m
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSCompletePersonalInfoViewController.h"
#import "HSPersonalInfoManagementDAO.h"
#import "YCDatePickerController.h"
#import "HSAddPhotoView.h"

#import "HSHttpRequestTool.h"
#import "HSQiniuService.h"

#import "HSPickHobbyTagViewController.h"

@interface HSCompletePersonalInfoViewController ()
@property (weak, nonatomic) IBOutlet HSAddPhotoView *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *datePickBtn;
@end

@implementation HSCompletePersonalInfoViewController

#pragma mark - Setup
- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTap];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"btn_chevron left_n"];
    
    [self.navigationItem setTitle:@"完善资料"];
    [UINavigationBar setAttributesWithTarget:self.navigationController TextColor:[UIColor whiteColor] FontOfSize:20];
    
    
    self.nickNameTextField.delegate = self;

 
    //头像初始化
    [self.avatarView setbackgroundImage:[UIImage imageNamed:@"img_DefaultAvatar"]];
    self.avatarView.layer.cornerRadius=self.avatarView.frame.size.width/2;
    self.avatarView.clipsToBounds=YES;
    self.avatarView.userInteractionEnabled = YES;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    
    //监听照片选取是否完成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoPicked)
                                                 name: @"HSPhotoPickedNotification"
                                               object: nil];
    
    datePicked = false;
    boyPicked = true;
    girlPicked = false;
    sexTag = @"0";
   
    [self.nextBtn setUserInteractionEnabled:NO];
    
    
}

#pragma mark 选取照片完成后，进行判断是否下一步
-(void)photoPicked{
    [self textFieldDidEndEditing:self.nickNameTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)boyBtnClick:(UIButton *)sender {
    
    if(!boyPicked){
        boyPicked = true;
        girlPicked = false;
        sexTag = @"0";
        [self.boyBtn setImage:[UIImage imageNamed:@"btn_symbolboy_h"] forState:UIControlStateNormal];
        [self.girlBtn setImage:[UIImage imageNamed:@"btn_symbolgirl_n"] forState:UIControlStateNormal];

    }
}
- (IBAction)girlBtnClick:(UIButton *)sender {
    
    if(!girlPicked){
        boyPicked = false;
        girlPicked = true;
        sexTag = @"1";
        [self.boyBtn setImage:[UIImage imageNamed:@"btn_symbolboy_n"] forState:UIControlStateNormal];
        [self.girlBtn setImage:[UIImage imageNamed:@"btn_symbolgirl_h"] forState:UIControlStateNormal];
        
    }
}

#pragma mark 下一步
- (IBAction)nextBtnClick:(UIButton *)sender {
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    //菊花加载
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在更新";
    
    [self uploadImageToQiNiuWithSuccess:^(NSString *imageURL) {
        HSLog(@"头像上传成功");
        //插入后台
        [self updateToDatabase:imageURL andCB:^(bool success) {
            if(success){
                //跳转
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                
                HSPickHobbyTagViewController *HSPickHobbyTagViewVC = (HSPickHobbyTagViewController *)[sb instantiateViewControllerWithIdentifier:@"HSPickHobbyTagViewController"];
                [self.navigationController pushViewController:HSPickHobbyTagViewVC animated:YES];

            }
            else{
//                HSLog(@"插入失败");

            }
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            [hud hide:YES];
        }];
        
        
        self.navigationController.navigationBar.userInteractionEnabled = YES;

        //头像修改、昵称、生日等信息
    } failure:^(NSString *error) {
        HSLog(@"%s,%@,上传七牛失败",__func__,error);
    }];
}

#pragma mark 更新到后台
- (void)updateToDatabase:(NSString *)imageURL andCB:(void(^)(bool))CB{
    //头像
    [HSPersonalInfoManagementDAO updatePersonLogo:imageURL andCallBack:^(bool success, NSString *error) {
        if(success){
            //昵称
            [HSPersonalInfoManagementDAO updatePersonNickname:self.nickNameTextField.text andCallBack:^(bool success, NSString *error) {
                if(success){
                    //生日
                    [HSPersonalInfoManagementDAO updatePersonBirthday:[self.datePickBtn currentTitle] andCallBack:^(bool success, NSString *error) {
                        if(success){
                            //性别
                            [HSPersonalInfoManagementDAO updatePersonSex:sexTag andCallBack:^(bool success, NSString *error) {
                                if(success){
                                    CB(true);
                                }else{
                                    CB(false);
                                    HSLog(error);
                                }
                            }];
                        }else{
                            CB(false);
                        }
                    }];
                }else{
                    HSLog(error);
                    CB(false);
                }
            }];
        }
        else{
            CB(false);
            HSLog(error);
        }
    }];
    
    
}
#pragma mark 

- (IBAction)datePickBtnClick:(UIButton *)sender {
    [self closeKeyboard];
    YCDatePickerController *vc = [YCDatePickerController datePickerControllerWithMode:UIDatePickerModeDate CompleteBlock:^(NSDate *date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateS = [formatter stringFromDate:date];
        
        [sender setTitle:dateS forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
//        [vc dismissViewControllerAnimated:YES completion:nil];
        
        //完成后，判断是否可以下一步
        datePicked = true;
        [self textFieldDidEndEditing:self.nickNameTextField];
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark 返回按钮
- (void)backClick{
    //如果用户token已经存在，则直接登录进入主界面
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"]){
//        
//        NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
//        //        //登录成功，跳转到成功页面
//        [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
//
//    }
//    else{
        [self.navigationController popViewControllerAnimated:YES];
//
//    }
}

#pragma mark 键盘返回
//关闭键盘
- (void)closeKeyboard{
    
        [self.nickNameTextField resignFirstResponder];
    
}
#pragma 关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    
    return YES;
}

#pragma mark 监听各个textfield状态
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //用户名重复需要判断吗？
    
    if(self.nickNameTextField.text.length > 0 && datePicked &&self.avatarView.imageID){
        [self.nextBtn setImage:[UIImage imageNamed:@"btn_nextgreen_n"] forState:UIControlStateNormal];
        [self.nextBtn setUserInteractionEnabled:YES];
    }
    else{
        [self.nextBtn setImage:[UIImage imageNamed:@"btn_next_n"] forState:UIControlStateNormal];
        [self.nextBtn setUserInteractionEnabled:NO];
    }
}


//    上传图片到七牛，获取URL
- (void)uploadImageToQiNiuWithSuccess:(void (^)(NSString *imageURL))success failure:(void (^)(NSString *error))failure {
    [HSQiniuService uploadImage:self.avatarView.image fileName:self.avatarView.imageID requestCB:^(BOOL code, id responseObject, NSString *error) {
        if (responseObject) {
            success(responseObject);
        } else {
            failure(error);
        }
    }];
}

#pragma mark viewwillappear
- (void)viewWillAppear:(BOOL)animated{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
//    
//    HSPickHobbyTagViewController *HSPickHobbyTagViewVC = (HSPickHobbyTagViewController *)[sb instantiateViewControllerWithIdentifier:@"HSPickHobbyTagViewController"];
//    [self.navigationController pushViewController:HSPickHobbyTagViewVC animated:YES];
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
