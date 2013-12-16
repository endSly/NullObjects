//
//  NSNull+NullObjects.m
//  NullObjects
//
//  Created by Endika Gutiérrez Salas on 16/12/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "NSNull+NullObjects.h"

#import <objc/runtime.h>

#import "NONull.h"

@implementation NSNull (NullObjects)

+ (void)actAsNullObject
{
    object_setClass([NSNull null], [NONull class]);
}

+ (void)actAsBlackhole
{
    object_setClass([NSNull null], [[NONull blackhole] class]);
}

+ (void)actAsNullObjectWithOptions:(NSDictionary *)options
{
    object_setClass([NSNull null], [NONull nullClassWithOptions:options]);
}

@end
