//
//  MenuTableViewController.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 07/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController

@property (copy, nonatomic) NSArray * items;
@property (copy, nonatomic) NSString * contentType;
@property (copy, nonatomic) NSNumber * parentCategoryID;

@end
