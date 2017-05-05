//
//  HSSportLableModel.m
//  WFAddUIView
//
//  Created by wangfei on 7/13/15.
//  Copyright (c) 2015 wangfei. All rights reserved.
//

#import "HSSportModel.h"

@implementation HSSportModel

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)sportModelWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSArray *)sportModels
{
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"sport.plist" ofType:nil]];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self sportModelWithDic:dict]];
    }
    return  arrayM;
}

- (BOOL)isEqual:(id)object {
    HSSportModel *model = (HSSportModel *)object;
    if ([self.sportID isEqualToString:model.sportID]) {
        return YES;
    }
    return NO;
}

@end
