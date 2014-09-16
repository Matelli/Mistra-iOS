//
//  MistraQuote+CRUD.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 16/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraQuote+CRUD.h"

@implementation MistraQuote (CRUD)

+ (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

+ (NSManagedObjectContext *)context
{
    return [[self appDelegate] managedObjectUserContext];
}

+ (instancetype)quote
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"MistraQuote" inManagedObjectContext:[self context]];
}

+ (NSArray *)allQuotes
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MistraQuote"];
    return [[self context] executeFetchRequest:request error:nil];
}

- (void)destroy
{
    [[MistraQuote context] deleteObject:self];
}

@end
