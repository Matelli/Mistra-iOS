//
//  MistraQuote+CRUD.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 16/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraQuote.h"

@interface MistraQuote (CRUD)

+ (AppDelegate*)appDelegate;
+ (NSManagedObjectContext*)context;
+ (instancetype)quote;
+ (NSArray*)allQuotes;
- (void)destroy;

@end
