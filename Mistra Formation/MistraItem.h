//
//  MistraItem.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 04/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

@import CoreData;

@interface MistraItem : NSManagedObject

@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * contentType;
@property (nonatomic, retain) NSString * title;

@end
