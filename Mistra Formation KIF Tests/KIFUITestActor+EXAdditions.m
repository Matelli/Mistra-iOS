//
//  KIFUITestActor+EXAdditions.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 06/10/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "KIFUITestActor+EXAdditions.h"

@implementation KIFUITestActor (EXAdditions)

- (void)navigateToBlogList
{
    [self waitForTappableViewWithAccessibilityLabel:@"Mistra Blog"];
    [self tapViewWithAccessibilityLabel:@"Mistra Blog"];
}

- (void)returnFromBlogListToHomeScreen
{
    [self waitForTappableViewWithAccessibilityLabel:@"Back"];
    [self tapViewWithAccessibilityLabel:@"Back"];
}

@end
