//
//  HSPMShareModel.m
//  LiveForest
//
//  Created by 余超 on 15/12/3.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "HSPMShareModel.h"
//#import "HSDataFormatHandle.h"

@implementation HSPMShareModel

- (void)setShare_img_path:(NSArray<NSString *> *)share_img_path {
    _share_img_path = share_img_path;
    
    self.imageURLs = [NSMutableArray array];
    for (NSString *urlStr in share_img_path) {
        [self.imageURLs addObject:[NSURL hs_URLWithString: urlStr]];
    }
}

+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
//    HSPMShareModel *model = [HSPMShareModel new];
//    model.
    
    return  array;
}

@end
