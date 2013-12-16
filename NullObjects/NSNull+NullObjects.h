//
//  NSNull+NullObjects.h
//  NullObjects
//
//  Created by Endika Gutiérrez Salas on 16/12/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (NullObjects)

+ (void)actAsNullObject;
+ (void)actAsBlackhole;
+ (void)actAsNullObjectWithOptions:(NSDictionary *)options;

@end
