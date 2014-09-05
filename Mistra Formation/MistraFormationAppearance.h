//
//  MistraFormationAppearance.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 20/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MistraFormationAppearance : NSObject

+ (void) apply;

+ (UIFont*)fontForNavigation;
+ (UIFont*)fontForMenu;
+ (UIFont*)fontForContactLabel;
+ (UIFont *)fontForContactDetail;
+ (UIFont*)fontFortableViewHeader;
+ (UIFont*)fontForTableViewCell;

+ (UIColor*)colorForNavigation;
+ (UIColor*)colorForTableViewHeaderText;
+ (UIColor*)colorForTableViewCellBackground;
+ (UIColor*)colorForContactCellDetailText;

@end
