//
//  NONull.h
//  NullObjects
//
//  Created by Endika Gutiérrez Salas on 16/12/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NONullDummyMethodBlock;
extern NSString * const NONullBlackHole;

@interface NONull : NSObject

/** 
 * Returns the singleton instance of <code>NONull</code>.
 * @return singleton instance of <code>NONull</code>. 
 */
+ (instancetype)null;

/**
 * Returns the singleton instance of <code>NONull</code> blackhole.
 * Blackhole returns self for any method.
 * @return singleton instance of <code>NONull</code> blackhole. 
 */
+ (instancetype)blackhole;

+ (Class)nullClassWithOptions:(NSDictionary *)options;

+ (instancetype)nullWithOptions:(NSDictionary *)options;

@end
