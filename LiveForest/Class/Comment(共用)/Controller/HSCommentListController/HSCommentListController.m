//
//  HSCommentListController.m
//  LiveForest
//
//  Created by 余超 on 16/1/26.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSCommentListController.h"

#import "YCTextView.h"
#import "HSCommentCell.h"

#import "UIView+YCKeyboardHandler.h"
#import "HSHttpRequestTool.h"


int rowCount = 3;


@interface HSCommentListController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet YCTextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation HSCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HSCommentCell" bundle:nil] forCellReuseIdentifier:@"HSCommentCell"];
    
    [self.textView yc_addKeyboardHandlerWithMoveView:self.commentView andInsertMaskButtonTo:self.view below:self.commentView];
//    [self.textView yc_addKeyboardHandlerWithMoveView:self.commentView];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    [_textView yc_removeKeyboardHandler];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _comments.count;
//    return rowCount;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSCommentCell" forIndexPath:indexPath];
//    cell.model
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%@",text);
    if ([text isEqualToString:@"\n"]) {
        [self sendComment:@"hhhh"];
        return NO;
    }
    return YES;
}

#pragma mark - Actions
- (void)sendComment:(NSString *)text {
    rowCount++;

//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    NSString *urlStr = @"http://api.liveforest.com/Social/Share/doShareComment";
    NSDictionary *para = @{@"user_token": [HSHttpRequestTool userToken],
                           @"share_id": _shareID,
                           @"share_comment_content": _textView.text,
                           @"comment_id": @0};
    
    [HSHttpRequestTool POST:urlStr parameters:para success:^(id responseObject) {
        ShowHud(@"评论成功", YES);
        if (_commentSuccessBlock) {
            _commentSuccessBlock(_textView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        ShowHud(@"评论失败", YES);
        HSLog(@"%s,%@",__func__, error);
    }];
}

@end
