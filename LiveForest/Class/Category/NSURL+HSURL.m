//
//  NSURL+HSURL.m
//  LiveForest
//
//  Created by 余超 on 15/12/2.
//  Copyright © 2015年 LiveForest. All rights reserved.
//

#import "NSURL+HSURL.h"

@implementation NSURL (HSURL)

+ (instancetype)hs_URLWithString:(NSString *)URLString {
    NSURL *url = [NSURL URLWithString:URLString];
    
    if (!url) {
        URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:URLString];
    }
    
    return url;
}

@end
