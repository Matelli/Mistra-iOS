//
//  BlogTestCase.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 06/10/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

@import UIKit;
@import XCTest;
#import <KIF/KIF.h>
#import "KIFUITestActor+EXAdditions.h"

@interface BlogTestCase : KIFTestCase

@end

@implementation BlogTestCase

- (void)beforeAll
{
    [tester navigateToBlogList];
}

- (void)afterAll
{
    [tester returnFromBlogListToHomeScreen];
}

- (void)testBlogList
{
    [tester waitForViewWithAccessibilityLabel:@"Blog"];
    [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Blog Content List TableView"];
}

- (void)testBlogDisplay
{
    [tester waitForViewWithAccessibilityLabel:@"Blog"];
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Blog Content List TableView"];
    [tester waitForViewWithAccessibilityLabel:@"Blog Entry Content"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
}

@end
