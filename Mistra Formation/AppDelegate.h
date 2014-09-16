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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContentContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *contentWriterContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectContentModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentContentStoreCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectUserContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectUserModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentUserStoreCoordinator;

- (void)saveContentContextWithCompletion:(contextSaveCompletion)completion;
- (void)saveUserContextWithCompletion:(contextSaveCompletion)completion;

@end
