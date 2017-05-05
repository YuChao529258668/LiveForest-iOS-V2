//
//  HSSelecteSportController.m
//  LiveForest
//
//  Created by 余超 on 16/2/23.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSSelecteSportController.h"
#import "HSHttpRequestTool.h"
#import "HSSportModel.h"

@interface HSSelecteSportController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<__kindof HSSportModel *> *sportModels;
@end

@implementation HSSelecteSportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sportModels = [HSSportModel sportModels];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    [self resumeSelection];
}

#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *ip = [tableView indexPathForSelectedRow];
    if (ip.row != indexPath.row) {
        [tableView deselectRowAtIndexPath:ip animated:NO];
    }
    return indexPath;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sportModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.sportModels[indexPath.row].sportName;
    cell.imageView.image = [UIImage imageNamed:self.sportModels[indexPath.row].selectedIcon];
    cell.imageView.contentMode = UIViewContentModeCenter;
    return cell;
}

#pragma mark - Actions
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completeBtnClick:(UIButton *)sender {
    //    获取选择的运动类型
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow]; // 如果用户没选中，则 ip == nil
    self.selectedSport = (ip==nil)? nil: self.sportModels[ip.row];
    
    if (self.completeBlock) {
        self.completeBlock(self.selectedSport);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 恢复选过的cell
- (void)resumeSelection {
    NSUInteger row = [self.sportModels indexOfObject:self.selectedSport];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end
