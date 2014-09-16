//
//  MistraArticle+CRUD.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 02/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraArticle+CRUD.h"

@implementation MistraArticle (CRUD)

+ (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

+ (NSManagedObjectContext *)context
{
    return [[self appDelegate] managedObjectContentContext];
}

- (void)destroy
{
    [[MistraArticle context] deleteObject:self];
}

@end
