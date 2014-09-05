//
//  MistraCategory+CRUD.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 02/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraCategory+CRUD.h"

@implementation MistraCategory (CRUD)

+ (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

+ (NSManagedObjectContext *)context
{
    return [[self appDelegate] managedObjectContext];
}

- (void)destroy
{
    [[MistraCategory context] deleteObject:self];
}

- (NSInteger)count
{
    return self.categories.count + self.articles.count;
}

- (MistraItem *)objectAtIndex:(NSUInteger)index
{
    MistraItem * returnValue = nil;
    if (index < self.categories.count)
    {
        returnValue = self.categories[index];
    }
    else
    {
        returnValue = self.articles[index - self.categories.count];
    }
    return returnValue;
}

- (MistraItem *)objectAtIndexedSubscript:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

- (NSArray *)allObjects
{
    return [self.categories.array arrayByAddingObjectsFromArray:self.articles.array];
}

static NSString *const kCategoriesKey = @"categories";

- (void)insertObject:(MistraCategory *)value inCategoriesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)removeObjectFromCategoriesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)insertCategories:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    [tmpOrderedSet insertObjects:values atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)removeCategoriesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)replaceObjectInCategoriesAtIndex:(NSUInteger)idx withObject:(MistraCategory *)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kCategoriesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)replaceCategoriesAtIndexes:(NSIndexSet *)indexes withCategories:(NSArray *)values {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kCategoriesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:values];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)addCategoriesObject:(MistraCategory *)value {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    NSUInteger idx = [tmpOrderedSet count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
    [tmpOrderedSet addObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
}

- (void)removeCategoriesObject:(MistraCategory *)value {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    NSUInteger idx = [tmpOrderedSet indexOfObject:value];
    if (idx != NSNotFound) {
        NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
        [tmpOrderedSet removeObject:value];
        [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
    }
}

- (void)addCategories:(NSOrderedSet *)values {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSUInteger valuesCount = [values count];
    NSUInteger objectsCount = [tmpOrderedSet count];
    for (NSUInteger i = 0; i < valuesCount; ++i) {
        [indexes addIndex:(objectsCount + i)];
    }
    if (valuesCount > 0) {
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
        [tmpOrderedSet addObjectsFromArray:[values array]];
        [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
        [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kCategoriesKey];
    }
}

- (void)removeCategories:(NSOrderedSet *)values {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kCategoriesKey]];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id value in values) {
        NSUInteger idx = [tmpOrderedSet indexOfObject:value];
        if (idx != NSNotFound) {
            [indexes addIndex:idx];
        }
    }
    if ([indexes count] > 0) {
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
        [tmpOrderedSet removeObjectsAtIndexes:indexes];
        [self setPrimitiveValue:tmpOrderedSet forKey:kCategoriesKey];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kCategoriesKey];
    }
}

static NSString *const kArticlesKey = @"articles";

- (void)insertObject:(MistraArticle *)value inArticlesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)removeObjectFromArticlesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)insertArticles:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    [tmpOrderedSet insertObjects:values atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)removeArticlesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)replaceObjectInArticlesAtIndex:(NSUInteger)idx withObject:(MistraArticle *)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kArticlesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)replaceArticlesAtIndexes:(NSIndexSet *)indexes withArticles:(NSArray *)values {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kArticlesKey];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:values];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)addArticlesObject:(MistraArticle *)value {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    NSUInteger idx = [tmpOrderedSet count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
    [tmpOrderedSet addObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
}

- (void)removeArticlesObject:(MistraArticle *)value {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    NSUInteger idx = [tmpOrderedSet indexOfObject:value];
    if (idx != NSNotFound) {
        NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
        [tmpOrderedSet removeObject:value];
        [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
    }
}

- (void)addArticles:(NSOrderedSet *)values {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSUInteger valuesCount = [values count];
    NSUInteger objectsCount = [tmpOrderedSet count];
    for (NSUInteger i = 0; i < valuesCount; ++i) {
        [indexes addIndex:(objectsCount + i)];
    }
    if (valuesCount > 0) {
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
        [tmpOrderedSet addObjectsFromArray:[values array]];
        [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
        [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kArticlesKey];
    }
}

- (void)removeArticles:(NSOrderedSet *)values {
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kArticlesKey]];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id value in values) {
        NSUInteger idx = [tmpOrderedSet indexOfObject:value];
        if (idx != NSNotFound) {
            [indexes addIndex:idx];
        }
    }
    if ([indexes count] > 0) {
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
        [tmpOrderedSet removeObjectsAtIndexes:indexes];
        [self setPrimitiveValue:tmpOrderedSet forKey:kArticlesKey];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kArticlesKey];
    }
}

@end
