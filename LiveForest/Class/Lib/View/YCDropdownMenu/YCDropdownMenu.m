//
//  YCDropdownMenu.m
//
//  Created by 余超 on 15/12/10.
//  Copyright © 2015年 yc. All rights reserved.
//

#import "YCDropdownMenu.h"
#import "YCDropdownMenuCell.h"

@interface YCDropdownMenu ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) float titleLabelHeight;
@property (nonatomic) BOOL isShow;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end


@implementation YCDropdownMenu
static NSString * reuseIdentifier = @"YCDropdownMenuCell";

#pragma mark - Initial
+ (instancetype)menuWithFrame:(CGRect)frame tableViewRowHeight:(CGFloat)rowHeight tableViewHeight:(float)height title:(NSString *)title {
    YCDropdownMenu *menu = [[self alloc]initWithFrame:frame tableViewRowHeight:rowHeight tableViewHeight:height title:title];
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame tableViewRowHeight:(CGFloat)rowHeight  tableViewHeight:(float)height title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        _isShow = NO;
        _titleLabelHeight = frame.size.height;
        _tableViewHeight = height;
        _tableViewRowHeight = rowHeight;
        
        [self setupMaskBtn];
        [self setupTitleLabelWithTitle:title];
        [self setupIndicator];
        [self setupTableView];
        [self setupTapGuesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame tableViewRowHeight:30 tableViewHeight:100 title:@"请选择"];
    return self;
}

#pragma mark - Layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];

    float width = self.frame.size.width;
    
    CGRect frame = CGRectZero;
    frame.size.width = width;
    frame.size.height = self.titleLabelHeight;
    self.titleLabel.frame = frame;
    
    float x = width - self.indicator.frame.size.width / 2;
    float y = self.titleLabel.center.y;
    self.indicator.center = CGPointMake(x,y);
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        CGRect frame = CGRectZero;
//        frame.origin.y = CGRectGetMaxY(self.titleLabel.frame);
//        frame.size.height = 0;
//        frame.size.width = width;
//        self.tableView.frame = frame;
//    });
    
//    self.titleLabel.backgroundColor = [UIColor blueColor];
//    self.tableView.backgroundColor = [UIColor blackColor];
//    self.backgroundColor = [UIColor yellowColor];
//    self.maskBtn.backgroundColor = [UIColor redColor];

}

#pragma mark - Setup
- (void)setupTitleLabelWithTitle:(NSString *)title {
    self.titleLabel = [[UILabel alloc]init];
//    self.titleLabel.text = title;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = NSMakeRange(0, title.length);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    self.titleLabel.attributedText = string;
    [self addSubview:self.titleLabel];
}

- (void)setupIndicator {
    UIImage *image = [UIImage imageNamed:@"btn_choose_n"];
    self.indicator = [[UIImageView alloc]initWithImage:image];
    [self addSubview:self.indicator];
}

- (void)setupTableView {
//    CGRect frame = CGRectZero;
//    frame.origin.y = self.titleLabelHeight;
//    frame.size.height = 0;
//    frame.size.width = self.frame.size.width;

//    self.tableView = [[UITableView alloc]initWithFrame:frame];
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.hidden = YES;
    self.tableView.rowHeight = self.tableViewRowHeight;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor  = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil]  forCellReuseIdentifier:reuseIdentifier];
//    [self addSubview:self.tableView];
}

- (void)setupTapGuesture {
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTitleLabel:)];
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:self.tap];
//    self.tap = tap;
//    self.tap.enabled = NO;
}

- (void)setupMaskBtn {
    self.maskBtn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.maskBtn.hidden = YES;
    [self.maskBtn addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.superview insertSubview:self.maskBtn belowSubview:self]; //此时superview==nil

}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    }
//    cell.textLabel.text = self.titles[indexPath.row];
    
    
    YCDropdownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.label.text = self.titles[indexPath.row];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.titleLabel.text = self.titles[indexPath.row];
    [self hideMenu];
    
    if ([self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Animation
- (void)animateTableView {

    CGPoint origin = [self.superview convertPoint:self.frame.origin toView:nil];
    origin.y += self.titleLabelHeight;
    CGSize size = CGSizeMake(self.frame.size.width, 0);
    
    CGRect frame = CGRectZero;
    frame.origin = origin;
    frame.size = size;
    
    CGRect frame2 = CGRectZero;
    frame2.origin = origin;
    frame2.size.width = self.frame.size.width;
    frame2.size.height = self.tableViewHeight;
    
    if (!self.isShow) {
        self.tableView.frame = frame;
//        [[UIApplication sharedApplication].windows.lastObject addSubview:self.tableView];
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
            self.tableView.frame = frame2;
        } completion:^(BOOL finished) {
        }];
    } else {
        self.tableView.frame = frame2;
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
            self.tableView.frame = frame;
        } completion:^(BOOL finished) {
            [self.tableView removeFromSuperview];
        }];
    }
}

//- (void)animateTableView {
//    
//    self.tableView.hidden = NO;
//    
//    CGRect frame = self.tableView.frame;
//    frame.size.height = self.isShow? 0: self.tableViewHeight;
//    
//    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
//        self.tableView.frame = frame;
//    } completion:^(BOOL finished) {
//        if (self.isShow) {
//            self.tableView.hidden = NO;
//        } else {
//            self.tableView.hidden = YES;
//        }
//    }];
//}

- (void)animateIndicator {
    CGAffineTransform transform = CGAffineTransformMakeRotation(179);
    if (self.isShow) {
        transform = CGAffineTransformMakeRotation(0);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.transform = transform;
    }];
}

#pragma mark - Guesture
- (void)tapTitleLabel:(UITapGestureRecognizer *)gesture {
    if (self.isShow) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

#pragma mark - Action
- (void)maskBtnClick:(UIButton *)btn {
    [self hideMenu];
}

- (void)showMenu {
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self.maskBtn];
    [window addSubview:self.tableView];

    [self animateIndicator];
    [self animateTableView];
    
//    self.maskBtn.hidden = NO;
    
    self.isShow = YES;

//    CGRect frame = self.frame;
//    frame.size.height = CGRectGetMaxY(self.tableView.frame);
//    self.frame = frame;
}

- (void)hideMenu {
    [self animateIndicator];
    [self animateTableView];
    
//    self.maskBtn.hidden = YES;
    [self.maskBtn removeFromSuperview];
    self.isShow = NO;

    CGRect frame = self.frame;
    frame.size.height = self.titleLabelHeight;
    self.frame = frame;
}

@end
