//
//  AppDelegate.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 07/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

typedef void(^contextSaveCompletion)(BOOL success, NSError * error);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *writerContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContextWithCompletion:(contextSaveCompletion)completion;

@end
