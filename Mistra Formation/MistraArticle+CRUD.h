//
//  MistraArticle+CRUD.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 02/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraArticle.h"
#import "AppDelegate.h"

@interface MistraArticle (CRUD)

+ (AppDelegate*)appDelegate;
+ (NSManagedObjectContext*)context;
- (void)destroy;

@end
