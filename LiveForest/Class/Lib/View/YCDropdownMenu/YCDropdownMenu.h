//
//  YCDropdownMenu.h
//
//  Created by 余超 on 15/12/10.
//  Copyright © 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCDropdownMenuDelegate;

@interface YCDropdownMenu : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicator;
@property (nonatomic, strong) UIButton *maskBtn;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) float tableViewHeight;
@property (nonatomic, assign) CGFloat tableViewRowHeight;

@property (nonatomic, weak) id<YCDropdownMenuDelegate> delegate;

//+ (instancetype)menuWithFrame:(CGRect)frame tableViewHeight:(float)height title:(NSString *)title;

+ (instancetype)menuWithFrame:(CGRect)frame tableViewRowHeight:(CGFloat)rowHeight tableViewHeight:(float)height title:(NSString *)title;

@end


@protocol YCDropdownMenuDelegate <NSObject>
@optional
- (void)menu:(YCDropdownMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end