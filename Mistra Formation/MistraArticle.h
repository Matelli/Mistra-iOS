//
//  MistraArticle.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 04/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

@import CoreData;
#import "MistraItem.h"

@class MistraCategory;

@interface MistraArticle : MistraItem

@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) MistraCategory *parentCategory;

@end
