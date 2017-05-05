//
//  HSSelectActivityController.m
//  LiveForest
//
//  Created by 余超 on 16/2/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSSelectActivityController.h"
#import "HSOfficialDisplayPictureActivity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HSSelectActivityController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *activitys;
@end

@implementation HSSelectActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getActivityList];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    HSOfficialDisplayPictureActivity *model = self.activitys[indexPath.row];
    cell.textLabel.text = model.activity_name;
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    cell.imageView.clipsToBounds = YES;
//    [cell.imageView sd_setImageWithURL:[NSURL hs_URLWithString:model.activity_img_path.firstObject] placeholderImage:[UIImage imageNamed:@"default_image"]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *ip = [tableView indexPathForSelectedRow];
    if (ip.row != indexPath.row) {
        [tableView deselectRowAtIndexPath:ip animated:NO];
    }
    return indexPath;
}

#pragma mark - Actions
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completeBtnClick:(UIButton *)sender {
    //    获取选择的活动
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow]; // 如果用户没选中，则 ip == nil
    self.selectedActivity = (ip==nil)? nil: self.activitys[ip.row];

    if (self.completeBlock) {
        self.completeBlock(self.selectedActivity);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 恢复选过的活动
- (void)resumeSelection {
    NSUInteger row = [self.activitys indexOfObject:self.selectedActivity];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)getActivityList {
    [HSOfficialDisplayPictureActivity getActivityListSuccess:^(NSArray *activitys) {
        self.activitys = activitys;
        [self.tableView reloadData];
        [self resumeSelection];
    } failure:^(NSString *error) {
        HSLog(@"%s, error = %@",__func__, error);
    }];
}

@end
