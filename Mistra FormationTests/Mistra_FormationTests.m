//
//  Mistra_FormationTests.m
//  Mistra FormationTests
//
//  Created by Jonathan Schmidt on 07/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

@import XCTest;

@interface Mistra_FormationTests : XCTestCase

@end

@implementation Mistra_FormationTests

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

- (void)testPass
{
    XCTAssert(YES, @"YES is not true... The rules of reality have been rewritten, oh noes !");
}

@end
