//
//  HSSemaphoreTool.m
//  LiveForest
//
//  Created by 余超 on 16/3/27.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSSemaphoreTool.h"

@interface HSSemaphoreTool ()
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) int finish;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) BOOL isWaiting;
@end

@implementation HSSemaphoreTool

- (instancetype)init {
    if (self = [super init]) {
        self.semaphore = dispatch_semaphore_create(0);
        self.total = 0;
        self.finish = 0;
        self.isWaiting = NO;
        [self addObserver:self forKeyPath:@"finish" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

//- (void)didChangeValueForKey:(NSString *)key {
////    super didichange
////    self.finish ++; 这个函数会被调用
//
//    HSLog(@"%s, %@", __func__, @"didChangeValueForKey");
//    HSLog(@"%@", NSStringFromSelector(_cmd));
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    HSLog(@"%@", NSStringFromSelector(_cmd));

    if ([keyPath isEqualToString:@"finish"]) {
        [self n];
    }
}

- (void)tt {
    self.isWaiting = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
//            ShowHint(@"保存成功");
            if (_willNotifyOnMainThread) {
                _willNotifyOnMainThread();
            }
            if (_notifyOnMainThread) {
                _notifyOnMainThread();
            }
            HSLog(@"%s,%@",__func__, @"执行");
        });

    });
    

}

- (void)signal {
//    dispatch_semaphore_signal(s);
    self.finish ++;
//    int f = ++self.finish;
//    [self setValue:@(f) forKey:@"finish"];
    HSLog(@"finish = %d", self.finish);

}

- (void)wait {
//    dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
    self.total ++;
    HSLog(@"total = %d", self.total);
    if (self.isWaiting == NO) {
        [self tt];
    }
}

- (void)n {
    if (self.finish == self.total) {
        HSLog(@"%d %d", self.finish, self.total);
            dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"finish"];
}


@end
