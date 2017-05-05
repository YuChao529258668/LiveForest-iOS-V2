//
//  HSPickHobbyTagViewController.m
//  LiveForest
//
//  Created by 傲男 on 16/1/24.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSPickHobbyTagViewController.h"
#import "HSPersonalInfoManagementDAO.h"
#import "HSSportLabelView.h"
#import "HSSportModel.h"
#import "HSUserModelDAO.h"
#import "HSUserModel.h"

#define kpadding 15
#define kCount 4
#define subViewH 65
#define subViewW 50
@interface HSPickHobbyTagViewController ()
@property (nonatomic, strong)UIView *addView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIButton  *backButton;
@property (nonatomic, strong)UIButton  *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

/**
 * 存储供用户选择的的运动标签
 */
@property (nonatomic, strong)NSArray *sportArray;

/**
 * 用户已经选择的运动id
 */
@property (nonatomic, strong) NSMutableArray *selectedID;
@end

@implementation HSPickHobbyTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"btn_chevron left_n"];
    
    [self.navigationItem setTitle:@"兴趣标签"];
    [UINavigationBar setAttributesWithTarget:self.navigationController TextColor:[UIColor whiteColor] FontOfSize:20];
    
//    HSLabelSelectView *selectView = [[HSLabelSelectView alloc]initWithSelectedID:self.selectedID isSingleSelection:NO];
//    [selectView show];
    [self.view addSubview:self.addView];
    
    [self.nextBtn setUserInteractionEnabled:NO];

    
    tagPickedCount = 0;
    
//    tagPickedNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tagPickedNotification)
                                                 name: @"tagPickedNotification"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tagNoPickedNotification)
                                                 name: @"tagNoPickedNotification"
                                               object: nil];
    


}
- (IBAction)nextBtnClick:(UIButton *)sender {
    //菊花加载
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在更新";

    //确定选取的id
    NSMutableArray *selectedIDs = [NSMutableArray array];
    
    for (id subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[HSSportLabelView class]]) {
            if ([subView sportButton].selected) {
                [selectedIDs addObject:[subView sportID]];
            }
        }
    }
    
    NSLog(@"%@",selectedIDs);
    [HSPersonalInfoManagementDAO updatePersonSportTag:selectedIDs andCallBack:^(bool success, NSString *error) {
        if(success){

//            [HSUserModelDAO getUserInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] orUserToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"] andRequestCB:^(HSUserModel *user) {
//                //判断是否为空，如果为空直接跳转
//                if(user == NULL){//
//                    HSLog(@"请求个人信息错误");
//                    ShowHud(@"更新个人信息失败",NO);
//                }
//                else{
//                    HSLog(@"请求个人信息成功");
//                    [HSUserModel setCurrentUser:user];
//                    //进入主界面
//                    NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
//                    //        //登录成功，跳转到成功页面
//                    [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
//                    [hud hide:YES];
//                }
//            }];
            //进入主界面
            NSString* notificatioName =notifyAppDelegateRootViewControllerNotification;
            //        //登录成功，跳转到成功页面
            [[NSNotificationCenter defaultCenter] postNotificationName:notificatioName object:self userInfo:@{@"rootViewControllerName" : @"HSHomeTabBarController"}];
            
        }else{
            HSLog(error);
        }
//        [hud hide:YES];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        
//    }
}

#pragma mark 选择运动标签
-(NSArray *)sportArray
{
    if (_sportArray == nil) {
        _sportArray = [HSSportModel sportModels];
    }
    return _sportArray;
}
-(UIView *)addView
{
    if (_addView == nil) {
        CGFloat paddingX = 30;
        CGFloat paddingY = 100;
        CGFloat addViewW = self.view.bounds.size.width - 2 * paddingX;
        //        CGFloat addViewW = 260;
        CGFloat addViewH = self.view.bounds.size.height -  paddingY - 60;
        //        CGFloat addViewH = 428;
        _addView = [[UIView alloc]initWithFrame:CGRectMake(paddingX, paddingY, addViewW, addViewH)];
        //适配
        //        CGPoint p= _addView.frame.origin;
        //        _addView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        //        CGRect f=_addView.frame;
        //        f.origin=p;
        //        _addView.frame=f;
        //圆角
        _addView.layer.cornerRadius = 10;
        _addView.layer.masksToBounds = YES;
        _addView.backgroundColor = [UIColor clearColor];
        
        //        [_addView addSubview:self.titleLabel];
        [_addView addSubview:self.scrollView];
        //        [_addView addSubview:self.backButton];
        //        [_addView addSubview:self.saveButton];
    }
    return _addView;
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        CGFloat scrollViewY = CGRectGetMaxY(self.titleLabel.frame);
        CGFloat scrollViewW = self.addView.bounds.size.width - 2 * kpadding;
        CGFloat scrollViewH = self.addView.bounds.size.height - 2 * 40;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kpadding,scrollViewY, scrollViewW, scrollViewH)];
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //添加子空间，9宫格
        CGFloat marginX = (scrollViewW - kCount * subViewW)/(kCount - 1);
        CGFloat marginY =  20;
        for (int i = 0; i < self.sportArray.count; i++) {
            //行 0，1，2----0；3，4，5---1
            int row = i/kCount;
            //列 0，3，6，----0; 1, 4, 5---1
            int col = i%kCount;
            
            HSSportLabelView *labelView = [[HSSportLabelView alloc]initWithIsSingleSelect:NO];
            labelView.delegate = self;
            HSSportModel *sportModel = self.sportArray[i];
            labelView.sportID = sportModel.sportID;
            labelView.sportLable.text = sportModel.sportName;
            
            [labelView.sportButton setBackgroundImage:[UIImage imageNamed:sportModel.normalIcon] forState:UIControlStateNormal];
            [labelView.sportButton setBackgroundImage:[UIImage imageNamed:sportModel.selectedIcon] forState:UIControlStateSelected];
            
            if ([self.selectedID containsObject:sportModel.sportID]) {
                labelView.sportButton.selected = YES;
            }
            //行x的数据主要关系是哪一列 col(从0开始)
            //列y的数据主要关系是哪一行 row（从0开始）
            CGFloat x = col * (marginX + subViewW);
            CGFloat y = row * (marginY + subViewH);
            
            labelView.frame = CGRectMake(x, y, subViewW, subViewH);
            
            [_scrollView addSubview:labelView];
        }
        CGFloat contentSizeH = CGRectGetMaxY([_scrollView.subviews.lastObject frame]) + 20;
        _scrollView.contentSize = CGSizeMake(scrollViewW, contentSizeH);
    }
    return _scrollView;
}

-(UIButton *)saveButton
{
    if (_saveButton == nil) {
        CGFloat x = CGRectGetMaxX(self.backButton.frame);
        CGFloat y = CGRectGetMaxY(self.scrollView.frame);
        CGFloat width = self.addView.bounds.size.width * 0.5;
        CGFloat height = 40;
        _saveButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
        [_saveButton setTitle:@"确定" forState:UIControlStateNormal];
        //        [_saveButton setImage:[UIImage imageNamed:@"ic_confirm"] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}



#pragma mark tagPickedNotification
- (void)tagPickedNotification{
    //记录选择标签个数
    tagPickedCount ++;
    
    [self.nextBtn setImage:[UIImage imageNamed:@"btn_nextgreen_n"] forState:UIControlStateNormal];
    [self.nextBtn setUserInteractionEnabled:YES];
}
- (void)tagNoPickedNotification{
    tagPickedCount -- ;
    if(tagPickedCount<1){
        [self.nextBtn setImage:[UIImage imageNamed:@"btn_next_n"] forState:UIControlStateNormal];
        [self.nextBtn setUserInteractionEnabled:NO];
    }
}
@end
