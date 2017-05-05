//
//  NSObject+YCRuntime.m
//  LiveForest
//
//  Created by 余超 on 16/1/28.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "NSObject+YCRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (YCRuntime)

//typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
//    OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
//    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
//                                            *   The association is not made atomically. */
//    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
//                                            *   The association is not made atomically. */
//    OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
//                                            *   The association is made atomically. */
//    OBJC_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
//                                            *   The association is made atomically. */
//};

//objc_setAssociatedObject
//- (void)setAssociatedObject:(id)value {
//    objc_setAssociatedObject(self, <#const void *key#>, value, <#objc_AssociationPolicy policy#>)
//}

@end
