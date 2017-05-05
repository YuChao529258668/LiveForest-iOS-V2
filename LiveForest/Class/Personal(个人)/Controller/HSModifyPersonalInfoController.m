//
//  HSModifyPersonalInfoController.m
//  LiveForest
//
//  Created by 余超 on 16/3/25.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSModifyPersonalInfoController.h"
#import "YCDatePickerController.h"

#import "HSAddPhotoView.h"
#import "HSPickView.h"

#import "HSUserModel.h"

#import "MJRefresh.h"
#import "HSUserTool.h"
#import "HSDataFormatHandle.h"
#import "HSHttpRequestTool.h"
#import "HSSemaphoreTool.h"

@interface HSModifyPersonalInfoController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet HSAddPhotoView *addPhotoView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *signatureTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;
@property (weak, nonatomic) IBOutlet UITextField *countyTF;
@property (weak, nonatomic) IBOutlet UITextField *scoreTF;
@property (weak, nonatomic) IBOutlet UIButton *selectDayBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) HSPickView *areaPickView;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *province;

@property (nonatomic, strong) dispatch_semaphore_t s;
@property (nonatomic, strong) HSSemaphoreTool *semaphoreTool;
@end

@implementation HSModifyPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HSUserModel *user = [HSUserModel currentUser];
    // 用于演示
    user = [HSUserModel test];
    
    _addPhotoView.layer.cornerRadius = _addPhotoView.width / 2;
//    [HSUserTool setUserAvatar:_addPhotoView.backgroundView];
    [HSUserTool setUserAvatarWithURLString:user.user_logo_img_path imageView:_addPhotoView.backgroundView];

    _nickNameTF.text = user.user_nickname;
    _signatureTF.text = user.user_sign;
    _birthdayTF.text = user.user_birthday;
    _countyTF.text = user.user_county_string;
    _scoreTF.text = [NSString stringWithFormat:@"%@",  user.user_credit_num];
    
    _nickNameTF.delegate = self;
    _signatureTF.delegate = self;
    _birthdayTF.delegate = self;
    _countyTF.delegate = self;
    
    [self addKVO]; // 观察text field。代理只能监听通过界面修改，kvo只能监听代码修改。
    
    
    self.title = @"个人资料";
    
    
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 40, 40);
    saveBtn.hidden = YES;
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn = saveBtn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc {
    [self removeKVO];
}

- (void)setUpMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkTextChanged];
    });
    return YES;
}

- (void)checkTextChanged {
    HSUserModel *user = [HSUserModel currentUser];
    if ([_nickNameTF.text isEqualToString: user.user_nickname]&[_signatureTF.text isEqualToString: user.user_sign]&[_birthdayTF.text isEqualToString: user.user_birthday]&[_countyTF.text isEqualToString: user.user_county_string]) {
        self.saveBtn.hidden = YES;
    } else {
        self.saveBtn.hidden = NO;
    }
}

#pragma mark - KVO

- (void)addKVO {
    [self.nickNameTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(self)];
    [self.signatureTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(self)];
    [self.countyTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(self)];
    [self.birthdayTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(self)];
}

- (void)removeKVO {
    [self.birthdayTF removeObserver:self forKeyPath:@"text" context:(__bridge void* _Nullable)self];
    [self.countyTF removeObserver:self forKeyPath:@"text" context:(__bridge void* _Nullable)self];
    [self.signatureTF removeObserver:self forKeyPath:@"text" context:(__bridge void* _Nullable)self];
    [self.nickNameTF removeObserver:self forKeyPath:@"text" context:(__bridge void* _Nullable)self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == (__bridge void * _Nullable)(self)) {
        if ([object isKindOfClass:[UITextField class]]) {
            [self checkTextChanged];
        }
    }
}

#pragma mark - Actions

- (void)saveBtnClick:(UIBarButtonItem *)btn {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在保存";
    
    __block BOOL success = YES;
    __block NSString *hint = @"保存成功";
    HSUserModel *user = [HSUserModel currentUser];
    __weak HSModifyPersonalInfoController *weakSelf = self;
    self.semaphoreTool = [HSSemaphoreTool new];
    
    self.semaphoreTool.willNotifyOnMainThread = ^ {
        hint = success? @"保存成功": @"保存失败";
    };
    self.semaphoreTool.notifyOnMainThread = ^ {
        [hud hide:YES];
        ShowHint(hint);
        if (success) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];            
        }
    };

    HSSemaphoreTool *tool = self.semaphoreTool;
    
    if (_addPhotoView.image) {
        [tool wait];
        [HSUserModel updateAvatar:_addPhotoView.image imageName:_addPhotoView.imageID success:^(NSString *imagePath) {
            HSLog(@"头像成功");
//            if (_didModifyAvatarBlock) {
//                _didModifyAvatarBlock(_addPhotoView.image);
//            }
//            user.modifyAvatar = _addPhotoView.image;
            user.modifyAvatarData = UIImagePNGRepresentation(_addPhotoView.image);
            [tool signal];
        } failure:^(NSString *error) {
            success = NO;
            HSLog(@"%s,%@",__func__, error);
            [tool signal];
        }];
    }
    
    if (![_nickNameTF.text isEqualToString:user.user_nickname]) {
        [tool wait];
        [HSUserModel updateNickName:_nickNameTF.text success:^{
            HSLog(@"昵称成功");
            [tool signal];
        } failure:^(NSString *error) {
            success = NO;
            HSLog(@"%s,%@",__func__, error);
            [tool signal];
        }];
    }
    
    if (![_signatureTF.text isEqualToString:user.user_sign]) {
        [tool wait];
        [HSUserModel updateSign:_signatureTF.text success:^{
            HSLog(@"签名成功");
            [tool signal];
        } failure:^(NSString *error) {
            success = NO;
            HSLog(@"%s,%@",__func__, error);
            [tool signal];
        }];
    }
    
    if (![_birthdayTF.text isEqualToString:user.user_birthday]) {
        [tool wait];
        [HSUserModel updateBirthday:_birthdayTF.text success:^{
            HSLog(@"生日成功");
            [tool signal];
        } failure:^(NSString *error) {
            success = NO;
            [tool signal];
            HSLog(@"%s,%@",__func__, error);
        }];
    }
    
    if (![_countyTF.text isEqualToString:user.user_county_string]) {
        [tool wait];
        [HSUserModel updateCounty:self.county WithProvince:self.province city:self.city success:^{
            HSLog(@"区域成功");
            [tool signal];
        } failure:^(NSString *error) {
            success = NO;
            HSLog(@"%s,%@",__func__, error);
            [tool signal];
        }];
    }
}

- (IBAction)selectBirthDayBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    YCDatePickerController *vc = [YCDatePickerController datePickerControllerWithMode:UIDatePickerModeDate CompleteBlock:^(NSDate *date) {
        _birthdayTF.text = [HSDataFormatHandle dayString_yyyy_MM_dd:date.timeIntervalSince1970];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)selectCountyBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];

    self.areaPickView = [[HSPickView alloc]initWithFrame:self.view.frame Level:AreaLevelDistrict];
    [self.areaPickView show];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickSaveCityInfo:) name:@"didClickSaveCity" object:nil];

}

-(void)didClickSaveCityInfo:(NSNotification *)noti
{
    self.countyTF.text = self.areaPickView.selectedCounty;
    self.city = self.areaPickView.selectedCity;
    self.county = self.areaPickView.selectedCounty;
    self.province = self.areaPickView.selectedProvince;
    
    //保存去后台
//    [self updatePersonCityWithCityID:areaID];
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickSaveCity" object:nil];
}

@end
