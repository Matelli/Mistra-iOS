//
//  AppDelegate.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 07/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "AppDelegate.h"
#import "MistraFormationAppearance.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <FlurrySDK/Flurry.h>

@implementation AppDelegate

@synthesize managedObjectContentContext = _managedObjectContentContext;
@synthesize contentWriterContext = _contentWriterContext;
@synthesize managedObjectContentModel = _managedObjectContentModel;
@synthesize persistentContentStoreCoordinator = _persistentContentStoreCoordinator;

@synthesize managedObjectUserContext = _managedObjectUserContext;
@synthesize managedObjectUserModel = _managedObjectUserModel;
@synthesize persistentUserStoreCoordinator = _persistentUserStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"7WPQ497962ZX39DXVHQ6" withOptions:launchOptions];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [MistraHelper helper];
    [application setMinimumBackgroundFetchInterval:604800];
    [MistraFormationAppearance apply];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[MistraHelper helper] updateContentWithCompletionHandler:completionHandler];
}

#pragma mark - Core Data methods
- (void)saveContentContextWithCompletion:(contextSaveCompletion)completion
{
    if (self.managedObjectContentContext != nil)
    {
        [self.managedObjectContentContext performBlock:^{
            NSError *error = nil;
            if ([self.managedObjectContentContext hasChanges] && ![self.managedObjectContentContext save:&error])
            {
                completion(NO, error);
                /*
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
                 */
            }
            else
            {
                if (self.contentWriterContext)
                {
                    [self.contentWriterContext performBlock:^
                     {
                         NSError *error = nil;
                         if ([self.contentWriterContext hasChanges] && ![self.contentWriterContext save:&error])
                         {
                             if (completion)
                             {
                                 completion(NO, error);
                             }
                             /*
                             // Replace this implementation with code to handle the error appropriately.
                             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                             abort();
                              */
                         }
                         else
                         {
                             if (completion)
                             {
                                 completion(YES, nil);
                             }
                         }
                     }];
                }
            }
        }];
    }
}

- (void)saveUserContextWithCompletion:(contextSaveCompletion)completion
{
    __weak __block NSManagedObjectContext *managedObjectContext = self.managedObjectUserContext;
    if (managedObjectContext != nil)
    {
        [managedObjectContext performBlock:^{
            NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
            {
                if (completion)
                {
                    completion(NO, error);
                }
                /*
                 // Replace this implementation with code to handle the error appropriately.
                 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                 abort();
                 */
            }
            else
            {
                if (completion)
                {
                    completion(YES, nil);
                }
            }
        }];
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContentContext
{
    if (_managedObjectContentContext != nil) {
        return _managedObjectContentContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentContentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContentContext.parentContext = self.contentWriterContext;
        _managedObjectContentContext.undoManager = nil;
    }
    return _managedObjectContentContext;
}

// Returns the managed object context for the application that is destined for background updates.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)contentWriterContext
{
    if (_contentWriterContext != nil) {
        return _contentWriterContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentContentStoreCoordinator];
    if (coordinator != nil) {
        _contentWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_contentWriterContext setPersistentStoreCoordinator:coordinator];
        [_contentWriterContext setUndoManager:nil];
    }
    return _contentWriterContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectContentModel
{
    if (_managedObjectContentModel != nil) {
        return _managedObjectContentModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MistraFormation" withExtension:@"momd"];
    _managedObjectContentModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectContentModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentContentStoreCoordinator
{
    if (_persistentContentStoreCoordinator != nil) {
        return _persistentContentStoreCoordinator;
    }
    
    NSURL *storeURL = [MistraHelper coreContentDatabaseURL];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path])
    {
        NSURL * precachedStoreURL = [[NSBundle mainBundle] URLForResource:@"MistraFormation" withExtension:@"sqlite"];
        if (precachedStoreURL && storeURL)
        {
            [[NSFileManager defaultManager] copyItemAtURL:precachedStoreURL toURL:storeURL error:nil];
        }
        
        NSDictionary * databaseFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:storeURL.path error:nil];
         NSDate * lastUpdate = databaseFileAttributes.fileModificationDate;
        if (!lastUpdate)
        {
            lastUpdate = [NSDate dateWithTimeIntervalSince1970:1];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdate forKey:@"MistraFormationLastUpdate"];
    }
    
    NSError *error = nil;
    _persistentContentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectContentModel]];
    if (![_persistentContentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentContentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectUserContext
{
    if (_managedObjectUserContext != nil) {
        return _managedObjectUserContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentUserStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectUserContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectUserContext.persistentStoreCoordinator = self.persistentUserStoreCoordinator;
        _managedObjectUserContext.undoManager = nil;
    }
    return _managedObjectUserContext;
}

- (NSManagedObjectModel *)managedObjectUserModel
{
    if (_managedObjectUserModel != nil) {
        return _managedObjectUserModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MistraUser" withExtension:@"momd"];
    _managedObjectUserModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectUserModel;
}

- (NSPersistentStoreCoordinator *)persistentUserStoreCoordinator
{
    if (_persistentUserStoreCoordinator != nil) {
        return _persistentUserStoreCoordinator;
    }
    
    NSURL *storeURL = [MistraHelper coreUserDatabaseURL];
    
    NSError *error = nil;
    _persistentUserStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectUserModel]];
    if (![_persistentUserStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentUserStoreCoordinator;
}

@end
