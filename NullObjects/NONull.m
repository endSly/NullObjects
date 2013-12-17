//
//  NONull.m
//  NullObjects
//
//  Created by Endika Gutiérrez Salas on 16/12/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import "NONull.h"

#import <objc/runtime.h>

NSString * const NONullDummyMethodBlock = @"NONullDummyMethodBlock";
NSString * const NONullBlackHole = @"NONullBlackHole";
NSString * const NONullTraceable = @"NONullTraceable";

static id dummyMethod(id self, SEL _cmd) {
    return nil;
}

static id dummyMethodBlackhole(id self, SEL _cmd) {
    return self;
}

static id dummyMethodStacktrace(id self, SEL _cmd) {
    NSArray *stacktrace = [NSThread callStackSymbols];
    // Remove top object that is call to this block
    stacktrace = [stacktrace subarrayWithRange:NSMakeRange(1, stacktrace.count - 1)];
    NSLog(@"[NullObjects] Called to null object with selector: %s\n"
          "Stacktrace:\n%@", sel_getName(_cmd), [stacktrace componentsJoinedByString:@"\n"]);
    
    return nil;
}

#define IMP_getter(method)                              \
(imp_implementationWithBlock(^IMP(id self, SEL _cmd) {  \
    return (IMP) (method);                                \
}))

#define IMP_getterBlock(block)                          \
(imp_implementationWithBlock(^IMP(id self, SEL _cmd) {  \
    return imp_implementationWithBlock(block);          \
}))

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
        const id block = options[NONullDummyMethodBlock];
        class_addMethod(object_getClass(NullClass), @selector(dummyMethodIMP), IMP_getterBlock(block), "^@:");
    }

    if ([options[NONullBlackHole] boolValue]) {
        class_addMethod(object_getClass(NullClass), @selector(dummyMethodIMP), IMP_getter(dummyMethodBlackhole), "^@:");
    }
    
    if ([options[NONullTraceable] boolValue]) {
        class_addMethod(object_getClass(NullClass), @selector(dummyMethodIMP), IMP_getter(dummyMethodStacktrace), "^@:");
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
