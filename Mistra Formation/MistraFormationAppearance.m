//
//  MistraFormationAppearance.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 20/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraFormationAppearance.h"
#import "MenuHeaderTableViewCell.h"
#import "HomeViewController.h"
#import "MenuTableViewCell.h"
#import "MenuTableViewController.h"
#import "ContentViewController.h"
#import "QuoteRequestViewController.h"
#import "ContactViewController.h"
#import "ContactTableViewCell.h"
#import "UIColor+HexColors.h"

@implementation MistraFormationAppearance

+ (void)apply
{
#pragma mark UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[self navigationBackground] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackIndicatorImage:[self backButton]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[self backButton]];
    [[UINavigationBar appearance] setTintColor:[self colorForNavigation]];
    [[UINavigationBar appearance] setTitleTextAttributes:
            @{NSForegroundColorAttributeName:[self colorForNavigation],
              NSFontAttributeName:[self fontForNavigation]}];
    
#pragma mark Generics
    
#pragma mark HomeViewcontroller
    [[UILabel appearanceWhenContainedIn:[HomeViewController class], nil] setFont:[self fontForMenu]];
    [[UILabel appearanceWhenContainedIn:[HomeViewController class], nil] setTextColor:[self colorForNavigation]];
    
#pragma mark MenuTableViewController
    [[UITableView appearanceWhenContainedIn:[MenuTableViewController class], nil] setBackgroundColor:[self colorForTableViewCellBackground]];
    [[UISearchBar appearance] setBarTintColor:[self colorForTableViewCellBackground]];
    [[UISearchBar appearance] setTintColor:[self colorForTableViewHeaderText]];
    [[UITableView appearanceWhenContainedIn:[MenuTableViewController class], nil] setBackgroundColor:[self colorForTableViewCellBackground]];
    [[UITableViewCell appearanceWhenContainedIn:[MenuTableViewController class], nil] setBackgroundColor:[self colorForTableViewCellBackground]];
    [[UITableView appearanceWhenContainedIn:[MenuTableViewController class], nil] setBackgroundColor:[self colorForTableViewCellBackground]];
    
#pragma mark MenuHeaderTableViewCell
    [[UILabel appearanceWhenContainedIn:[MenuHeaderTableViewCell class], nil] setFont:[self fontFortableViewHeader]];
    [[UILabel appearanceWhenContainedIn:[MenuHeaderTableViewCell class], nil] setTextColor:[self colorForTableViewHeaderText]];
    [[MenuHeaderTableViewCell appearance] setBackgroundColor:[self colorForTableViewCellBackground]];
    
#pragma mark MenuTableViewCell
    [[UILabel appearanceWhenContainedIn:[MenuTableViewCell class], nil] setFont:[self fontForTableViewCell]];
    [[MenuTableViewCell appearance] setBackgroundColor:[self colorForTableViewCellBackground]];
    
#pragma mark ContentViewController
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:[self colorForTableViewHeaderText]];
    
#pragma mark QuoteRequestViewController
    [[UILabel appearanceWhenContainedIn:[QuoteRequestViewController class], nil] setFont:[self fontForTableViewCell]];
}

#pragma mark - UIImages

+ (UIImage*)navigationBackground
{
    UIImage * gradient;
    
    if ([[UIScreen mainScreen] bounds].size.width==375.0f) {
        gradient = [UIImage imageNamed: @"bg-degade-head-6"];
    }
    else if ([[UIScreen mainScreen] bounds].size.width==414.0f) {
        gradient = [UIImage imageNamed: @"bg-degade-head-6+"];
    }
    else{
        gradient = [UIImage imageNamed: @"bg-degade-head"];
        
    }
    
    UIImage * mirroredGradient = [UIImage imageWithCGImage:gradient.CGImage
                                                     scale:gradient.scale
                                               orientation:UIImageOrientationUpMirrored];
    UIImage * resizable = [mirroredGradient resizableImageWithCapInsets:UIEdgeInsetsZero
                                                           resizingMode:UIImageResizingModeStretch];
    return resizable;
}

+ (UIImage*)backButton
{
    return [[UIImage imageNamed:@"arrow_right"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
}

+ (UIImage*)cellBackground
{
    return [[UIImage imageNamed:@"Degrade_Cellule"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
}

#pragma mark - Fonts

+ (UIFont*)fontForNavigation
{
    return [UIFont fontWithName:@"HelveticaNeue" size:20.0];
}

+ (UIFont*)fontForMenu
{
    return [UIFont fontWithName:@"HelveticaNeue" size:14.0];
}

+ (UIFont*)fontForContactLabel
{
    return [UIFont fontWithName:@"HelveticaNeue" size:17.0];
}

+ (UIFont *)fontForContactDetail
{
    return [UIFont fontWithName:@"HelveticaNeue" size:13.0];
}

+ (UIFont*)fontFortableViewHeader
{
    return [UIFont fontWithName:@"Neris-Thin" size:30.0];
}

+ (UIFont*)fontForTableViewCell
{
    return [UIFont fontWithName:@"HelveticaNeue" size:15.0];
}

#pragma mark - Colors

+ (UIColor*)colorForNavigation
{
    return [UIColor whiteColor];
}

+ (UIColor*)colorForTableViewHeaderText
{
    return [UIColor colorWithHexString:@"f46aa8"];
}

+ (UIColor*)colorForTableViewCellBackground
{
    return [UIColor colorWithHexString:@"f5f2f6"];
}

+ (UIColor*)colorForContactCellDetailText
{
    return [UIColor colorWithHexString:@"711098"];
}

@end
