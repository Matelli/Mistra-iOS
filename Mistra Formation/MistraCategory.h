//
//  MistraCategory.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 04/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

@import CoreData;
#import "MistraItem.h"

@class MistraArticle, MistraCategory;

@interface MistraCategory : MistraItem

@property (nonatomic, retain) NSData * summary;
@property (nonatomic, retain) NSOrderedSet *articles;
@property (nonatomic, retain) NSOrderedSet *categories;
@property (nonatomic, retain) MistraCategory *parentCategory;
@end

@interface MistraCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(MistraArticle *)value inArticlesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArticlesAtIndex:(NSUInteger)idx;
- (void)insertArticles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArticlesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArticlesAtIndex:(NSUInteger)idx withObject:(MistraArticle *)value;
- (void)replaceArticlesAtIndexes:(NSIndexSet *)indexes withArticles:(NSArray *)values;
- (void)addArticlesObject:(MistraArticle *)value;
- (void)removeArticlesObject:(MistraArticle *)value;
- (void)addArticles:(NSOrderedSet *)values;
- (void)removeArticles:(NSOrderedSet *)values;
- (void)insertObject:(MistraCategory *)value inCategoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCategoriesAtIndex:(NSUInteger)idx;
- (void)insertCategories:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCategoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCategoriesAtIndex:(NSUInteger)idx withObject:(MistraCategory *)value;
- (void)replaceCategoriesAtIndexes:(NSIndexSet *)indexes withCategories:(NSArray *)values;
- (void)addCategoriesObject:(MistraCategory *)value;
- (void)removeCategoriesObject:(MistraCategory *)value;
- (void)addCategories:(NSOrderedSet *)values;
- (void)removeCategories:(NSOrderedSet *)values;
@end
