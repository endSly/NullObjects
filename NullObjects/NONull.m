//
//  NONull.m
//  NullObjects
//
//  Created by Endika Gutiérrez Salas on 16/12/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "NONull.h"

#import <objc/runtime.h>

NSString * const NONullDummyMethodBlock = @"NODummyMethodBlock";
NSString * const NONullBlackHole = @"NONullBlackHole";

id dummyMethod(id self, SEL _cmd) {
    return nil;
}

id dummyMethodBlackhole(id self, SEL _cmd) {
    return self;
}

IMP getDummyMethodBlackhole(id self, SEL _cmd) {
    return (IMP) dummyMethodBlackhole;
}

@implementation NONull

+ (instancetype)null
{
    static NONull *nullSingleton = nil;
    if (!nullSingleton) {
        nullSingleton = [[NONull alloc] init];
    }
    return nullSingleton;
}

+ (instancetype)blackhole
{
    static NONull *blackhole = nil;
    if (!blackhole) {
        blackhole = [NONull nullWithOptions:@{NONullBlackHole: @YES}];
    }
    return blackhole;
}

+ (instancetype)nullWithOptions:(NSDictionary *)options
{
    return [[[self nullClassWithOptions:options] alloc] init];
}

+ (Class)nullClassWithOptions:(NSDictionary *)options;
{
    static int nullId = 1;
    
    // Build new class
    NSString *newClassName = [NSString stringWithFormat:@"NONull$DynamicClass-%i", nullId++];
    Class NullClass = objc_allocateClassPair(self, [newClassName UTF8String], 0);

    if (options[NONullDummyMethodBlock]) {
        id dummyMethodBlock = options[NONullDummyMethodBlock];

        IMP (^dummyMethodImpBuilder)(id self, SEL _cmd) = ^ IMP (id self, SEL _cmd) {
            return imp_implementationWithBlock(dummyMethodBlock);
        };

        class_addMethod(object_getClass(NullClass),
                        @selector(dummyMethodIMP),
                        imp_implementationWithBlock(dummyMethodImpBuilder),
                        "^@:");
    }

    if ([options[NONullBlackHole] boolValue]) {
        class_addMethod(object_getClass(NullClass), @selector(dummyMethodIMP), (IMP) getDummyMethodBlackhole, "^@:");
    }

    objc_registerClassPair(NullClass);

    return NullClass;
}

+ (IMP)dummyMethodIMP
{
    // Default dummy method implementation
    return (IMP) dummyMethod;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    class_addMethod(self, sel, [self dummyMethodIMP], "@@:");
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    class_addMethod(object_getClass(self), sel, [self dummyMethodIMP], "@@:");
    return YES;
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[NONull class]];
}

@end
