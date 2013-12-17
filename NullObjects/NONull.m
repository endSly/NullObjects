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
NSString * const NONullDefineExplicitConversions = @"NONullDefineExplicitConversions";

#pragma mark - Predefined dummy methods

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


#pragma mark - Defines

#define IMP_getter(method)                              \
(imp_implementationWithBlock(^IMP(id self, SEL _cmd) {  \
    return (IMP) (method);                              \
}))

#define IMP_getterBlock(block)                          \
(imp_implementationWithBlock(^IMP(id self, SEL _cmd) {  \
    return imp_implementationWithBlock(block);          \
}))

#define SINGLETON(name, constructor)        \
+ (instancetype)name                        \
{                                           \
    static NONull *name##Singleton = nil;   \
    if (!name##Singleton) {                 \
        name##Singleton = constructor;      \
    }                                       \
    return name##Singleton;                 \
}

#pragma mark - NONull class

@implementation NONull

#pragma mark Constructors

SINGLETON(null,      [NONull nullWithOptions:nil])
SINGLETON(blackhole, [NONull nullWithOptions:@{NONullBlackHole: @YES}])
SINGLETON(traceable, [NONull nullWithOptions:@{NONullTraceable: @YES}])

+ (instancetype)nullWithOptions:(NSDictionary *)options
{
    return [[[self nullClassWithOptions:options] alloc] init];
}


#pragma mark Class Builder

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
    
    if ([options[NONullDefineExplicitConversions] boolValue]) {
        class_addMethod(NullClass, @selector(stringValue),   IMP_getterBlock(^{ return @""; }),  "@@:");
        class_addMethod(NullClass, @selector(intValue),      IMP_getterBlock(^{ return 0; }),    "i@:");
        class_addMethod(NullClass, @selector(integerValue),  IMP_getterBlock(^{ return 0; }),    "l@:");
        class_addMethod(NullClass, @selector(longLongValue), IMP_getterBlock(^{ return 0L; }),   "q@:");
        class_addMethod(NullClass, @selector(floatValue),    IMP_getterBlock(^{ return 0.0f; }), "f@:");
        class_addMethod(NullClass, @selector(boolValue),     IMP_getterBlock(^{ return NO; }),   "i@:");
        class_addMethod(NullClass, @selector(length),        IMP_getterBlock(^{ return 0; }),    "i@:");
        class_addMethod(NullClass, @selector(count),         IMP_getterBlock(^{ return 0; }),    "i@:");
    }

    objc_registerClassPair(NullClass);

    return NullClass;
}

#pragma mark Dyanamic calls support

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

#pragma mark Comparator

- (BOOL)isEqual:(id)object
{
    // All null object should act as equal objects
    return [object isKindOfClass:[NONull class]];
}

@end
