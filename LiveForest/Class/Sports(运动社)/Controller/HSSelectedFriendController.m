//
//  HSSelectedFriendController.m
//  LiveForest
//
//  Created by 余超 on 16/2/18.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSSelectedFriendController.h"
#import "HSFriend.h"
#import "HSHttpRequestTool.h"

@interface HSSelectedFriendController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<__kindof HSFriend *> *friends;
@end

@implementation HSSelectedFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    [self getFriendList];
}

+ (instancetype)selectedFriendController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HSSelectedFriendController *vc = [sb instantiateViewControllerWithIdentifier:@"HSSelectedFriendController"];
    return vc;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.friends[indexPath.row].user_nickname;
    return cell;
}

#pragma mark - Actions
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completeBtnClick:(UIButton *)sender {
//    获取选择的好友
    self.selectedFriends = @[].mutableCopy;
    NSArray *indexPathes = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPathes) {
        [self.selectedFriends addObject:self.friends[indexPath.row]];
    }
    
    if (self.completeBlock) {
        self.completeBlock(self.selectedFriends);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 恢复选过的好友
- (void)resumeSelection {
    for (HSFriend *friend in self.selectedFriends) {
        NSUInteger row = [self.friends indexOfObject:friend];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)getFriendList {
    [HSFriend getFriendListSuccess:^(NSArray *friends) {
        self.friends = friends;
        [self.tableView reloadData];
        [self resumeSelection];
    } failure:^(NSString *error) {
        HSLog(@"%s,%@",__func__, error);
    }];
}

@end
