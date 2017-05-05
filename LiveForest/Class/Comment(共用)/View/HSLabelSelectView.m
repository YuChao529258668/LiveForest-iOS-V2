//
//  HSLabelSelectView.m
//  WFAddUIView
//
//  Created by wangfei on 7/11/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSLabelSelectView.h"
#import "HSSportLabelView.h"
#import "HSSportModel.h"
#define kpadding 15 
#define kCount 4
#define subViewH 65
#define subViewW 50
@interface HSLabelSelectView()<SportLabelViewDelegate>
@property (nonatomic, strong)UIView *addView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIButton  *backButton;
@property (nonatomic, strong)UIButton  *saveButton;

/**
 * 存储供用户选择的的运动标签
 */
@property (nonatomic, strong)NSArray *sportArray;

/**
 * 用户已经选择的运动id
 */
@property (nonatomic, strong)NSMutableArray *selectedID;

/**
 *  是否是单选
 */
@property (nonatomic, assign)BOOL isSingleSelection;

@end
@implementation HSLabelSelectView
/**
 *  初始化
 *
 *  @param selectedID        当前选择的id
 *  @param isSingleSelection 是否是单选
 *
 *  @return self
 */
-(instancetype)initWithSelectedID:(NSMutableArray *)selectedID isSingleSelection:(BOOL)isSingleSelection
{
    self = [super init];
    if (self) {
        
        self.selectedID = selectedID;
        
        self.isSingleSelection = isSingleSelection;
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        
        [self addSubview:self.addView];
        //设置灰色透明
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
    }
    return self;
}
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
        CGFloat paddingY = 70;
        CGFloat addViewW = self.bounds.size.width - 2 * paddingX;
//        CGFloat addViewW = 260;
        CGFloat addViewH = self.bounds.size.height - 2 * paddingY;
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
        _addView.backgroundColor = [UIColor whiteColor];

        [_addView addSubview:self.titleLabel];
        [_addView addSubview:self.scrollView];
        [_addView addSubview:self.backButton];
        [_addView addSubview:self.saveButton];
    }
    return _addView;
}
-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kpadding, 0, self.addView.bounds.size.width, 40)];
        if (self.isSingleSelection) {
            _titleLabel.text = @"选择关联的运动";
        }else{
            _titleLabel.text = @"选择运动项目";
        }
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        //横线
//        CGFloat lineY = CGRectGetMaxY(_titleLabel.frame);
//        CGFloat lineW = self.addView.bounds.size.width - 2 * kpadding;
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kpadding, lineY, lineW, 1)];
//        line.backgroundColor = [UIColor grayColor];
//        [self.addView addSubview:line];
    }
    return _titleLabel;
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
            
            HSSportLabelView *labelView = [[HSSportLabelView alloc]initWithIsSingleSelect:self.isSingleSelection];
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
-(UIButton *)backButton
{
    if (_backButton == nil) {
        CGFloat x = 0;
        CGFloat y = CGRectGetMaxY(self.scrollView.frame);
        CGFloat width = self.addView.bounds.size.width * 0.5;
        CGFloat height = 40;
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
//        [_backButton setImage:[UIImage imageNamed:@"ic_cancel2"] forState:UIControlStateNormal];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
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
-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
-(void)back
{
    [self removeFromSuperview];
}
#pragma -mark 用户选择确定按钮
-(void)save
{
    //确定选取的id
    NSMutableArray *selectedIDs = [NSMutableArray array];

    for (id subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[HSSportLabelView class]]) {
            if ([subView sportButton].selected) {
                [selectedIDs addObject:[subView sportID]];
            }
        }
    }
    //如果是单选（at运动）可以一个不选
    if (!self.isSingleSelection) {
        if (selectedIDs.count == 0) {
            UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择运动类型" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alerView show];
            return;
        }

    }
    NSLog(@"%@",selectedIDs);
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:selectedIDs forKey:@"selectedIDs"];
    //通知上个页面修改
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSportLabel" object:self
                                                      userInfo:dictM];
    //关闭
    [self removeFromSuperview];
}

#pragma mark - 代理实现单选
- (void)sportLalelViewDidClickButton:(HSSportLabelView *)sportLabelView
{
    for (id subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[HSSportLabelView class]]) {
            if ([subView sportButton].selected) {
                [subView sportButton].selected = NO;
            }
        }
    }

}
@end
