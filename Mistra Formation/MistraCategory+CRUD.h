//
//  MistraCategory+CRUD.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 02/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraCategory.h"
#import "AppDelegate.h"

@interface MistraCategory (CRUD)

+ (AppDelegate*)appDelegate;
+ (NSManagedObjectContext*)context;

- (void)destroy;
- (NSInteger)count;
- (MistraItem*)objectAtIndex:(NSUInteger)index;
- (MistraItem*)objectAtIndexedSubscript:(NSUInteger)index;
- (NSArray*)allObjects;

@end
