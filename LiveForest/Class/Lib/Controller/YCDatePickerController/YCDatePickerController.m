//
//  YCDatePickerController.m
//  LiveForest
//
//  Created by 余超 on 16/1/15.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "YCDatePickerController.h"

@interface YCDatePickerController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) UIDatePickerMode mode;
@end

@implementation YCDatePickerController

#pragma mark - Public

+ (instancetype)datePickerControllerWithMode:(UIDatePickerMode)mode CompleteBlock:(void (^)(NSDate *date))block {
    YCDatePickerController *vc = [[self alloc]init];
    vc.mode = mode;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.completeBlock = block;
    return vc;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.datePicker.datePickerMode = self.mode;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDismiss:)];
    [self.view addGestureRecognizer:tap];
}

- (void)dealloc {
    HSLog(@"YCDatePickerController释放了");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HSLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HSLog(@"%s",__func__);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    HSLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HSLog(@"%s",__func__);
}

#pragma mark - Actions

- (IBAction)cancleBtnClick:(UIButton *)btn {
    if (_cancelBlock) {
        _cancelBlock();
        _cancelBlock = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)decideBtnClick:(UIButton *)sender {
    if (_completeBlock) {
        _completeBlock(self.datePicker.date);
        _completeBlock = nil; // 防止循环引用
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapToDismiss:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
