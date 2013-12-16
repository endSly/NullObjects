//
//  NullObjectsTests.m
//  NullObjectsTests
//
//  Created by Endika Gutiérrez Salas on 12/16/13.
//  Copyright (c) 2013 Endika Gutiérrez Salas. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NullObjects.h"

@interface NullObjectsTests : XCTestCase

@end

@implementation NullObjectsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNull
{
    id simpleNull = (id) [NONull null];
    
    XCTAssertNoThrow([simpleNull lastObject], @"[NONull null] never should raise exception");
    XCTAssertNoThrow([[simpleNull firstObject] stringValue], @"[NONull null] never should raise exception");
    XCTAssertNoThrow([simpleNull objectForKey:@"key"], @"[NONull null] never should raise exception");
    
    XCTAssertEqual((__bridge void *)[simpleNull firstObject], nil, @"[NONull null] should return nil for any method");
    XCTAssertEqual((__bridge void *)[simpleNull objectForKey:@"key"], nil, @"[NONull null] should return nil for any method");
}

- (void)testBlackholeNull
{
    id blackhole = (id) [NONull blackhole];
    
    XCTAssertNoThrow([blackhole lastObject], @"[NONull blackhole] never should raise exception");
    XCTAssertNoThrow([[blackhole firstObject] stringValue], @"[NONull blackhole] never should raise exception");
    XCTAssertNoThrow([blackhole objectForKey:@"key"], @"[NONull blackhole] never should raise exception");
    
    XCTAssertEqual([blackhole firstObject], blackhole, @"[NONull null] should return self for any method");
    XCTAssertEqual([[[blackhole firstObject] firstObject] string], blackhole, @"[NONull null] should return self for any method");
    XCTAssertEqual([blackhole objectForKey:@"key"], blackhole, @"[NONull null] should return self for any method");
    XCTAssertEqual(blackhole[@"key"], blackhole, @"[NONull null] should return self for any method");
}

- (void)testNSNullActAsNullObject
{
    [NSNull actAsNullObject];
    
    id simpleNull = (id) [NSNull null];
    
    XCTAssertNoThrow([simpleNull lastObject], @"[NSNull actAsNullObject] never should raise exception");
    XCTAssertNoThrow([[simpleNull firstObject] stringValue], @"[NONull null] never should raise exception");
    XCTAssertNoThrow([simpleNull objectForKey:@"key"], @"[NONull null] never should raise exception");
    
    XCTAssertEqual((__bridge void *)[simpleNull firstObject], nil, @"[NONull null] should return nil for any method");
    XCTAssertEqual((__bridge void *)[simpleNull objectForKey:@"key"], nil, @"[NONull null] should return nil for any method");
}

- (void)testNSNullActAsBlackholeNull
{
    [NSNull actAsBlackhole];
    
    id blackhole = (id) [NSNull null];
    
    XCTAssertNoThrow([blackhole lastObject], @"[NONull blackhole] never should raise exception");
    XCTAssertNoThrow([[blackhole firstObject] stringValue], @"[NONull blackhole] never should raise exception");
    XCTAssertNoThrow([blackhole objectForKey:@"key"], @"[NONull blackhole] never should raise exception");
    
    XCTAssertEqual([blackhole firstObject], blackhole, @"[NONull null] should return self for any method");
    XCTAssertEqual([[[blackhole firstObject] firstObject] string], blackhole, @"[NONull null] should return self for any method");
    XCTAssertEqual([blackhole objectForKey:@"key"], blackhole, @"[NONull null] should return self for any method");
    XCTAssertEqual(blackhole[@"key"], blackhole, @"[NONull null] should return self for any method");
}


@end
