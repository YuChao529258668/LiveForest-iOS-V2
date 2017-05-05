//
//  HSChallengeEventFlowController.m
//  LiveForest
//
//  Created by 余超 on 16/3/29.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSChallengeEventFlowController.h"
#import "HSShareDetailController.h"

#import "HSChallengeEventFlowCell.h"

#import "HSRecommendShareModel.h"

@interface HSChallengeEventFlowController ()
@property (nonatomic, strong) NSArray *shares;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HSChallengeEventFlowController

+ (instancetype)challengeEventFlowController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSChallengeEventFlowController *vc = [sb instantiateViewControllerWithIdentifier:@"HSChallengeEventFlowController"];
    return vc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"事件流";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.7];
//    self.view.backgroundColor = [UIColor clearColor];
    
//    [self.view addSubview:self.backgroundView];
//    [self.view sendSubviewToBack:self.backgroundView];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 600;
    
    [self getShareList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)getShareList {
    [HSRecommendShareModel getShareListWithUserID:_shareModel.user_id challengeID:_shareModel.share_in_challenge_id Success:^(NSArray *models) {
        self.shares = models;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    self.backgroundView.hidden = YES;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.backgroundView.hidden = NO;
//}

- (IBAction)hh:(id)sender {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shares.count;
//    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSChallengeEventFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSChallengeEventFlowCell" forIndexPath:indexPath];
    cell.model = self.shares[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSShareDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"HSShareDetailController"];
    
    vc.recommendShareModel = self.shares[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  494;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //    NSLog(@"%@",NSStringFromCGRect(self.bubbleMenu.frame));
//    CGPoint offset = scrollView.contentOffset;
//    _bubbleMenu.transform = CGAffineTransformMakeTranslation(0, offset.y);
//}


@end
