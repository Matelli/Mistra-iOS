//
//  MistraQuote.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 16/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

@import CoreData;


@interface MistraQuote : NSManagedObject

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * message;

@end
