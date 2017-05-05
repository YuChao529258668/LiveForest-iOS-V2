//
//  YCCycleScrollView.m
//  LiveForest
//
//  Created by 余超 on 15/12/28.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "YCCycleScrollView.h"
#import "YCCycleScrollCell.h"

float cellWidth = 296;
float cellHeight = 142;
float leftInset = 16;
float minimumLineSpacing = 8;

@interface YCCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YCCycleScrollView

//+ (instancetype)viewWithOrigin:(CGPoint)origin {
//    CGRect frame
//    YCCycleScrollView *view = [[YCCycleScrollView alloc]initWithFrame:frame];
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCollectionView];
        [self setupPageControl];
        _canSelectCell = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCollectionView];
        [self setupPageControl];
        _canSelectCell = YES;
    }
    return self;
}

- (void)setModels:(NSArray *)models {
    _models = models;
    _pageControl.numberOfPages = models.count;
    _pageControl.hidden = models.count<2?YES:NO;
    [_collectionView reloadData];
}

#pragma mark - Setup
- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, leftInset, 0, leftInset);
    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = cellHeight;
    
    UICollectionView *cv = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [cv registerNib:[UINib nibWithNibName:@"YCCycleScrollCell" bundle:nil] forCellWithReuseIdentifier:@"YCCycleScrollCell"];
    cv.dataSource = self;
    cv.delegate = self;
    cv.backgroundColor = [UIColor whiteColor];
    //    cv.pagingEnabled = YES;
    cv.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:cv];
    _collectionView = cv;
}

- (void)setupPageControl {
    CGRect frame = CGRectMake(0, cellHeight + 12, cellWidth, 8);
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:frame];
        page.numberOfPages = _models.count;
    page.userInteractionEnabled = NO;
    
    UIColor *color = [UIColor colorWithRed:0x00/255.0 green:0xA5/255.0 blue:0x9A/255.0 alpha:1];
    page.currentPageIndicatorTintColor = color;
    page.pageIndicatorTintColor = [UIColor grayColor];
    
    CGPoint center = page.center;
    center.x = [UIScreen mainScreen].bounds.size.width / 2;
    page.center = center;
    
    [self addSubview:page];
    _pageControl = page;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    相对于window的中点转换成相对于scrollview的点，然后判断点在哪个cell上。
    double x = scrollView.frame.size.width / 2;
    CGPoint point = CGPointMake(x, 0);
    CGPoint point2 = [scrollView convertPoint:point fromView:nil];
    CGPoint point3 = CGPointMake(point2.x, scrollView.frame.size.height / 2);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point3];
    if (indexPath == nil) return; // 如果是在两个cell之间的空白地方
    self.pageControl.currentPage = indexPath.row;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCCycleScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCCycleScrollCell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    cell.canSelected = _canSelectCell;
    return cell;
}

@end
