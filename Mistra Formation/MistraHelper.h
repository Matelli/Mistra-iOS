//
//  MistraHelper.h
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 11/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BlockRSSParser/RSSParser.h>
#import "MistraCategory+CRUD.h"
#import "MistraArticle+CRUD.h"

#define kMistraHelperContentTypeTraining @"MistraHelperContentTypeTraining"
#define kMistraHelperContentTypeTutorial @"MistraHelperContentTypeTutorial"

#define kMistraDatabaseUpdatedNotification @"fr.mistra.MistraDatabaseUpdatedNotification"
#define kMistraHelperRSSFeedUpdatedNotification @"fr.mistra.MistraHelperRSSFeedUpdatedNotification"
#define kMistraHelperRSSFeedUpdateFailedNotification @"fr.mistra.MistraHelperRSSFeedUpdateFailedNotification"

@interface MistraHelper : NSObject

@property (strong, nonatomic) NSArray * rssBlogContent;

+ (NSArray *)contentForType:(NSString*)contentType;
+ (NSURL*) contentDirectoryURL;
+ (NSURL*) coreDatabaseURL;

/**
 *  The singleton instance for MistraHelper
 *
 *  @return The current instance of the MistraHelper singleton
 */
+ (instancetype)helper;

/**
 *  Update the content if necessary, send a MistraHelperContentUpdatedNotification notification when completed
 *
 *  @param completionHandler If called via application:performFetchWithCompletionHandler: you must pass the completionhandler here. Otherwise pass nil.
 */
- (void)updateContentWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 *  Start updating the Mistra blog RSS feed, send a MistraHelperRSSFeedUpdatedNotification notification when completed or MistraHelperRSSFeedUpdateFailedNotification when the update fails
 */
- (void)updateMistraRSSFeed;

/**
 *  Return an article by id
 *
 *  @param articleID The ID of the article
 *
 *  @return A MistraArticle managed object representing the article or nil if no article with this ID exists
 */
+ (MistraArticle*)articleWithID:(NSUInteger)articleID;

/**
 *  Return a category by ID
 *
 *  @param categoryID The ID of the category
 *
 *  @return A MistraCategory managed object representing the category or nil if no category with this ID exists
 */
+ (MistraCategory*)categoryWithID:(NSUInteger)categoryID;

/**
 *  Returns the articles of a given content type matching a given search string
 *
 *  @param searchString The string to match
 *  @param contentType  The content type to match
 *
 *  @return An array of articles ordered by title matching the given string and content type
 */
+ (NSArray*)articlesForSearchString:(NSString*)searchString inContentType:(NSString*)contentType;

/**
 *  Return the correct URL for an article
 *
 *  @param articleID The ID of the article
 *
 *  @return A NSURL pointing to the article
 */
+ (NSURL*)urlForArticleWithID:(NSUInteger)articleID;

/**
 *  Sends a request for quote to the Mistra server containing the provided informations
 *
 *  @param informations A dictionary containing the values of the quote form (at least an email)
 */
- (void)sendQuoteRequestWithInformations:(NSDictionary*)informations;

+ (void)openAddress;
+ (void)openPhone;
+ (void)openEmail;
+ (void)openFacebook;
+ (void)openTwitter;
+ (void)openGooglePlus;
+ (void)openLinkedIn;
+ (void)openViadeo;
+ (void)openStackOverflow;

@end
