//
//  MistraHelper.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 11/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MistraHelper.h"
#import <AFNetworking/AFNetworking.h>
#import <AFOnoResponseSerializer/AFOnoResponseSerializer.h>
#import <Ono/Ono.h>
#import <ZipArchive/ZipArchive.h>
#import "NSError+Display.h"
#import "AppDelegate.h"
#import <FlurrySDK/Flurry.h>
#import <BlockRSSParser/RSSParser.h>

@import MessageUI;

@interface MistraHelper () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic, strong) AFHTTPSessionManager * apiSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager * quoteSessionManager;

@end

@implementation MistraHelper

+ (instancetype)helper
{
    static MistraHelper *_sharedMistraHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMistraHelper = [[self alloc] init];
    });
    
    return _sharedMistraHelper;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadContent];
    }
    return self;
}

#pragma mark - Private Accessors

- (NSOperationQueue *)operationQueue
{
    // Using dispatch_once to ensure we don't create multiple queue
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        self->_operationQueue = [[NSOperationQueue alloc] init];
    });
    
    return _operationQueue;
}

- (AFHTTPSessionManager *)apiSessionManager
{
    // Using dispatch_once to ensure we don't create multiple session manager
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        self->_apiSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.mistra.fr"]];
        self->_apiSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _apiSessionManager;
}

- (AFHTTPSessionManager *)quoteSessionManager
{
    // Using dispatch_once to ensure we don't create multiple session manager
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      self->_quoteSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.mistra.fr/"]];
                      self->_quoteSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                      self->_quoteSessionManager.responseSerializer = [AFOnoResponseSerializer HTMLResponseSerializer];
                  });
    
    return _quoteSessionManager;
}

#pragma mark - Public Methods

+ (NSArray *)contentForType:(NSString*)contentType
{
    NSFetchRequest * categoriesRequest = [NSFetchRequest fetchRequestWithEntityName:@"MistraCategory"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"contentType LIKE %@ AND parentCategory == nil", contentType];
    
    categoriesRequest.predicate = predicate;
    categoriesRequest.returnsObjectsAsFaults = NO;
    categoriesRequest.sortDescriptors = [self sortDescriptorsForCoreDatabase];
    
    NSArray * trainingRootCategories = [[MistraCategory context] executeFetchRequest:categoriesRequest error:nil];
    
    NSFetchRequest * articlesRequest = [NSFetchRequest fetchRequestWithEntityName:@"MistraArticle"];
    articlesRequest.predicate = predicate;
    articlesRequest.returnsObjectsAsFaults = NO;
    articlesRequest.sortDescriptors = [self sortDescriptorsForCoreDatabase];
    
    NSArray * trainingRootArticles = [[MistraArticle context] executeFetchRequest:articlesRequest error:nil];
    
    return [trainingRootCategories arrayByAddingObjectsFromArray:trainingRootArticles];
}

+ (NSURL *)contentDirectoryURL
{
    // lazyLoading of the content directory url
    static NSURL * __ContentDirectoryURL;
    // Using dispatch_once to ensure we don't set the static multiple times
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      __ContentDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
                      __ContentDirectoryURL = [__ContentDirectoryURL URLByAppendingPathComponent:@"Mistra" isDirectory:YES];
                      [[NSFileManager defaultManager] createDirectoryAtURL:__ContentDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
                      [__ContentDirectoryURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
                  });
    
    return __ContentDirectoryURL;
}

+ (NSURL *)coreContentDatabaseURL
{
    return [[self contentDirectoryURL] URLByAppendingPathComponent:@"MistraFormation.sqlite"];
}

+ (NSURL *)coreUserDatabaseURL
{
    return [[[self contentDirectoryURL] URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"MistraUser.sqlite"];
}

+ (MistraArticle *)articleWithID:(NSUInteger)articleID
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MistraArticle"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"articleID.unsignedIntegerValue == %i", articleID];
    request.predicate = predicate;
    return [[[MistraArticle context] executeFetchRequest:request error:nil] firstObject];
}

+ (MistraCategory *)categoryWithID:(NSUInteger)categoryID
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MistraCategory"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"categoryID.unsignedIntegerValue == %i", categoryID];
    request.predicate = predicate;
    return [[[MistraArticle context] executeFetchRequest:request error:nil] firstObject];
}

+ (NSURL *)urlForArticleWithID:(NSUInteger)articleID
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.mistra.fr/index.php?view=article&id=%lu", (unsigned long)articleID]];
}

+ (NSArray *)articlesForSearchString:(NSString *)searchString inContentType:(NSString *)contentType
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MistraArticle"];
    NSPredicate * searchPredicate = [NSPredicate predicateWithFormat:@"contentType LIKE %@ AND title contains[cd] %@", contentType, searchString];
    NSSortDescriptor * sortTitleAscending = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    request.predicate = searchPredicate;
    request.sortDescriptors = @[sortTitleAscending];
    
    NSArray * returnValue = [[MistraArticle context] executeFetchRequest:request error:nil];
    if (!returnValue)
    {
        returnValue = @[];
    }
    
    return returnValue;
}

- (void) updateContentWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDate * currentDate = [NSDate date];
    NSDate * lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MistraFormationLastUpdate"];
    [self.apiSessionManager GET:[NSString stringWithFormat:@"/incre.php?date=%.0f",lastUpdateDate.timeIntervalSince1970]
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if (responseObject)
         {
             NSManagedObjectContext * updateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
             updateContext.parentContext = [MistraCategory context];
             updateContext.undoManager = nil;
             
             [updateContext performBlockAndWait:^
              {
                  NSArray * trainingArray = responseObject[@"formation"];
                  NSArray * tutorialArray = responseObject[@"tutoriels"];
                  
                  for (NSDictionary * currentCategory in trainingArray)
                  {
                      [[self class] recursivelyUpdateContext:updateContext
                                                    withItem:currentCategory
                                              parentCategory:nil
                                                 contentType:kMistraHelperContentTypeTraining];
                  }
                  for (NSDictionary * currentCategory in tutorialArray)
                  {
                      [[self class] recursivelyUpdateContext:updateContext
                                                    withItem:currentCategory
                                              parentCategory:nil
                                                 contentType:kMistraHelperContentTypeTutorial];
                  }
                  
                  if ([updateContext save:nil])
                  {
                      [[MistraCategory appDelegate] saveContentContextWithCompletion:^(BOOL success, NSError *error)
                       {
                           if (success)
                           {
                               //The CoreDatabase was updated correctly and successfully
                               
                               //We can set the last update time to the date at the start of this process
                               [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"MistraFormationLastUpdate"];
                               
                               //If there are articles we can launch the images' background download
                               NSSet * articlesSet = [[self class] articlesSetFromMistraDictionary:responseObject];
                               if (articlesSet.count)
                               {
                                   [self downloadImagesAsynchronouslyFromArticles:articlesSet];
                                   
                                   // And notify the OS that we have new content
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMistraDatabaseUpdatedNotification object:nil];
                                   if (completionHandler)
                                   {
                                       completionHandler(UIBackgroundFetchResultNewData);
                                   }
                               }
                               else
                               {
                                   // No new articles
                                   if (completionHandler)
                                   {
                                       completionHandler(UIBackgroundFetchResultNoData);
                                   }
                               }
                           }
                           else
                           {
                               //Something went wrong when updating the database...
                               if (completionHandler)
                               {
                                   completionHandler(UIBackgroundFetchResultFailed);
                               }
                           }
                       }];
                  }
                  else
                  {
                      //Something went wrong when updating the database...
                      if (completionHandler)
                      {
                          completionHandler(UIBackgroundFetchResultFailed);
                      }
                  }
              }];
             
         }
         else if (completionHandler)
         {
             // No response object, we got a successfull call but the data was either absent or malformed.
             completionHandler(UIBackgroundFetchResultFailed);
         }
     }
                     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         if (completionHandler)
         {
             // The call ended in failure, either with an HTTP error code or network failure.
             completionHandler(UIBackgroundFetchResultFailed);
         }
     }];
}

- (void)updateMistraRSSFeed
{
    NSURL * url = [NSURL URLWithString:@"http://feeds.feedburner.com/MistraFormationBlog"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems)
     {
         [NSKeyedArchiver archiveRootObject:feedItems toFile:[[MistraHelper contentDirectoryURL] URLByAppendingPathComponent:@"mistraRSS.rss"].path];
         self.rssBlogContent = feedItems;
         [[NSNotificationCenter defaultCenter] postNotificationName:kMistraHelperRSSFeedUpdatedNotification object:self.rssBlogContent];
     }
                              failure:^(NSError *error)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMistraHelperRSSFeedUpdateFailedNotification object:error];
    }];
}

- (void)sendQuoteRequests
{
    for (MistraQuote * quote in [MistraQuote allQuotes])
    {
        [self sendQuoteRequestWithQuote:quote];
    }
}

+ (NSSet *)setFromArray:(NSArray *)array
{
    NSMutableSet * returnValue = [NSMutableSet set];
    for (NSDictionary * currentContent in array)
    {
        [returnValue unionSet:[self decomposeJson:currentContent]];
    }
    return returnValue;
}

+ (void)openAddress
{
    [Flurry logEvent:@"Opened Address"];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    
    urlComponents.scheme = @"http";
    urlComponents.host = @"maps.apple.com";
    urlComponents.query = @"q=19+Rue+Béranger,+75003+Paris";
    
    if (![[UIApplication sharedApplication] canOpenURL:urlComponents.URL])
    {
        urlComponents.host = @"maps.google.com";
    }
    [[UIApplication sharedApplication] openURL:urlComponents.URL];
    
}

+ (void)openPhone
{
    [Flurry logEvent:@"Opened Phone"];
    NSString *stringURL = @"telprompt:0182522525";
    NSURL *url = [NSURL URLWithString:stringURL];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Votre appareil ne gère pas la téléphonie" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

+ (void)openEmailFromViewController:(UIViewController*)viewController
{
    [Flurry logEvent:@"Opened Email"];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController * mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = [MistraHelper helper];
        [mailController setToRecipients:@[NSLocalizedString(@"contact_email", @"email de contact pour mistra")]];
        [mailController setSubject:@"Demande de contact"];
        [viewController presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"En compte de messagerie doit être configuré pour envoyer un email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

+ (void)openFacebook
{
    [Flurry logEvent:@"Opened Facebook"];
    NSString *stringURL = @"fb://MistraFormation";
    NSURL *url = [NSURL URLWithString:stringURL];
    if (![[UIApplication sharedApplication] canOpenURL:url])
    {
        stringURL = @"http://www.facebook.com/MistraFormation";
        url = [NSURL URLWithString:stringURL];
    }
    [[UIApplication sharedApplication] openURL:url];
    
}

+ (void)openTwitter
{
    [Flurry logEvent:@"Opened Twitter"];
    NSString *stringURL = @"twitter://user?screen_name=MistraFormation";
    NSURL *url = [NSURL URLWithString:stringURL];
    if (![[UIApplication sharedApplication] canOpenURL:url])
    {
        stringURL = @"http://www.twitter.com/MistraFormation";
        url = [NSURL URLWithString:stringURL];
    }
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)openGooglePlus
{
    [Flurry logEvent:@"Opened GooglePlus"];
    NSString *stringURL = @"https://plus.google.com/109094744273458679858/about";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)openLinkedIn
{
    [Flurry logEvent:@"Opened LinkedIn"];
    NSString *stringURL = @"https://www.linkedin.com/groups/Mistra-Formation-3704423";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)openViadeo
{
    [Flurry logEvent:@"Opened Viadeo"];
    NSString *stringURL = @"http://www.viadeo.com/fr/company/mistra-formation";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)openStackOverflow
{
    [Flurry logEvent:@"Opened StackOverflow"];
    NSString *stringURL = @"http://www.google.com";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Private Methods

/**
 *  Check that all our content (except the CoreDatabase) is present and functional, load it from bundle otherwise
 */
- (void)loadContent
{
    [MistraCategory context];
    
    self.rssBlogContent = [NSKeyedUnarchiver unarchiveObjectWithFile:[[MistraHelper contentDirectoryURL] URLByAppendingPathComponent:@"mistraRSS.rss"].path];
    
    if (!self.rssBlogContent)
    {
        self.rssBlogContent = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"mistraRSS" ofType:@"rss"]];
    }
    
    //The rest is done asynchronously to ensure smooth experience
    [self.operationQueue addOperationWithBlock:^
    {
        [self sendQuoteRequests];
        
        // Check if images directory exists
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[MistraHelper contentDirectoryURL]  URLByAppendingPathComponent:@"images"].path])
        {
            // Images are not present, we need to inflate them from zip
            ZipArchive * archiver = [[ZipArchive alloc] init];
            [archiver UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"images" ofType:@"zip"]];
            [archiver UnzipFileTo:[MistraHelper contentDirectoryURL].path overWrite:YES];
            [archiver UnzipCloseFile];
        }
    }];
}

+ (NSArray *)sortDescriptorsForCoreDatabase
{
    static NSArray * sortDescriptors;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSortDescriptor * sortTitleAscending = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        sortDescriptors = @[sortTitleAscending];
    });
    
    return sortDescriptors;
}

- (void) downloadImagesAsynchronouslyFromArticles:(NSSet*)articles
{
    // Creating a predicate to filter every article with images by searching for the html img tag
    NSPredicate * htmlImagePredicate = [NSPredicate predicateWithFormat:@"SELF['content'] CONTAINS[cd] '<img'"];
    
    // Filtering the articles to isolate the ones containing images by using previous predicate
    NSSet * articlesWithImageSet = [articles filteredSetUsingPredicate:htmlImagePredicate];
    
    // Creating the set that will contain every image path from our content (using NSSet because enumeration will be faster and we will avoid duplicates)
    NSMutableSet * htmlPaths = [NSMutableSet set];
    
    // For each article containing an image
    for (NSDictionary * articleWithImage in articlesWithImageSet)
    {
        NSString * articleString = articleWithImage[@"content"];
        
        // We will search for the img tag and extract it
        NSRegularExpression * imageSourceFinderExpression = [[NSRegularExpression alloc] initWithPattern:@"<img.*?src=\\\"(.*?)\\\"" options:NSRegularExpressionCaseInsensitive error:nil];
        
        // For each img tag we find
        [imageSourceFinderExpression enumerateMatchesInString:articleString options:NSMatchingReportCompletion range:NSRangeFromString([NSString stringWithFormat:@"(0, %lu)",(unsigned long)articleString.length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
         {
             NSString * imageTag = [articleString substringWithRange:result.range];
             
             // As long as the image URL is not a local file
             if ([imageTag rangeOfString:@"file:"].location == NSNotFound)
             {
                 // We extract the URL
                 NSRange rangeOfSource = [imageTag rangeOfString:@"src=\""];
                 
                 // And add it to the list of images path
                 // this code is potentially unsafe since dealing with range and stuff, so we put it in a try-catch block
                 @try {
                     [htmlPaths addObject:[imageTag substringWithRange:NSRangeFromString([NSString stringWithFormat:@"(%lu,%lu)",(unsigned long)rangeOfSource.location+rangeOfSource.length,(unsigned long)imageTag.length-rangeOfSource.location-rangeOfSource.length-1])]];
                 }
                 @catch (NSException *exception) {
                     NSLog(@"exception : %@", exception);
                     // failed to extract string
                     
                 }
                 
             }
         }];
    }
    
    //Creating a weakSelf to avoid capture within the block
    [self.apiSessionManager setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location)
     {
         NSString * url = downloadTask.originalRequest.URL.path;
         url = [url stringByReplacingCharactersInRange:NSRangeFromString(@"(0,1)") withString:@""];
         return [[MistraHelper contentDirectoryURL] URLByAppendingPathComponent:url.stringByRemovingPercentEncoding];
     }];
    
    for (NSString * htlmPath in htmlPaths)
    {
        NSString * path = [NSString stringWithFormat:@"%@/%@",[MistraHelper contentDirectoryURL].path, htlmPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            if (![[NSFileManager defaultManager] fileExistsAtPath:path.stringByDeletingLastPathComponent.stringByRemovingPercentEncoding isDirectory:nil])
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent.stringByRemovingPercentEncoding
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil];
            }
            NSURLComponents * urlComponents = [NSURLComponents componentsWithString:@"http://www.mistra.fr"];
            urlComponents.path = [NSString stringWithFormat:@"/%@",htlmPath];
            NSURLRequest * request = [NSURLRequest requestWithURL:urlComponents.URL];
            NSURLSessionDownloadTask * downloadTask = [self.apiSessionManager downloadTaskWithRequest:request
                                                                                          progress:nil
                                                                                       destination:nil
                                                                                 completionHandler:nil];
            [downloadTask resume];
        }
    }
}

+ (void) recursivelyUpdateContext:(NSManagedObjectContext*)context withItem:(NSDictionary*)item parentCategory:(MistraCategory*)parentCategory contentType:(NSString*)contentType
{
    if ([item[@"type"] isEqualToString:@"article"])
    {
        // We're adding an Article
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MistraArticle"];
        NSPredicate * searchPredicate = [NSPredicate predicateWithFormat:@"itemID.unsignedIntegerValue == %i AND contentType LIKE %@", [item[@"id"] unsignedIntegerValue], contentType];
        request.predicate = searchPredicate;
        MistraArticle * managedArticle = [[context executeFetchRequest:request error:nil] firstObject];
        if (!managedArticle)
        {
            // The article does not exist, we create it
            managedArticle = [NSEntityDescription insertNewObjectForEntityForName:@"MistraArticle"
                                                            inManagedObjectContext:context];
            managedArticle.itemID = item[@"id"];
            managedArticle.content = [item[@"content"] dataUsingEncoding:NSUTF8StringEncoding];
            managedArticle.title = item[@"title"];
            managedArticle.contentType = contentType;
            if (parentCategory)
            {
                [parentCategory addArticlesObject:managedArticle];
            }
        }
        else
        {
            // The article exists, it might be an update
            if ([item.allKeys containsObject:@"content"])
            {
                managedArticle.content = [item[@"content"] dataUsingEncoding:NSUTF8StringEncoding];
            }
            if ([item.allKeys containsObject:@"title"])
            {
                managedArticle.title = item[@"title"];
            }
        }
    }
    else
    {
        // We're adding a Category
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MistraCategory"];
        NSPredicate * searchPredicate = [NSPredicate predicateWithFormat:@"itemID.unsignedIntegerValue == %i AND contentType LIKE %@", [item[@"id"] unsignedIntegerValue], contentType];
        request.predicate = searchPredicate;
        MistraCategory * managedCategory = [[context executeFetchRequest:request error:nil] firstObject];
        if (!managedCategory)
        {
            // The category does not exist, we create it
            managedCategory = [NSEntityDescription insertNewObjectForEntityForName:@"MistraCategory"
                                                            inManagedObjectContext:context];
            managedCategory.itemID = item[@"id"];
            managedCategory.summary = [item[@"description"] dataUsingEncoding:NSUTF8StringEncoding];
            managedCategory.title = item[@"title"];
            managedCategory.contentType = contentType;
            if (parentCategory)
            {
                [parentCategory addCategoriesObject:managedCategory];
            }
        }
        else
        {
            // The category exists, there may be an update
            if ([item.allKeys containsObject:@"title"])
            {
                managedCategory.title = item[@"title"];
            }
            if ([item.allKeys containsObject:@"description"])
            {
                managedCategory.summary = [item[@"description"] dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        // The category now exists (wether it did or not before), we can call the recursion with it as parent for each item of our content
        for (NSDictionary * contentItem in item[@"content"])
        {
            [self recursivelyUpdateContext:context withItem:contentItem parentCategory:managedCategory contentType:contentType];
        }
        
        // Once we're done updating the category, we sort it (and since this is not a NSMutableOrderedSet, we do it the hard way...)
        // First the categories
        if (managedCategory.categories.count)
        {
            NSArray * sortedCategories = [managedCategory.categories sortedArrayUsingDescriptors:[self sortDescriptorsForCoreDatabase]];
            [managedCategory removeCategories:managedCategory.categories];
            [managedCategory addCategories:[NSOrderedSet orderedSetWithArray:sortedCategories]];
        }
        // Then the articles
        if (managedCategory.articles.count)
        {
            NSArray * sortedArticles = [managedCategory.articles sortedArrayUsingDescriptors:[self sortDescriptorsForCoreDatabase]];
            [managedCategory removeArticles:managedCategory.articles];
            [managedCategory addArticles:[NSOrderedSet orderedSetWithArray:sortedArticles]];
        }
    }
}

+ (NSSet*) articlesSetFromMistraDictionary:(NSDictionary*)mistraDictionary
{
    NSSet * jsonSet = [self setFromMistraJson:mistraDictionary];
    
    NSPredicate * articlesPredicate = [NSPredicate predicateWithFormat:@"SELF['type'] == 'article'"];
    
    return [jsonSet filteredSetUsingPredicate:articlesPredicate];
}

+ (NSSet*) categoriesSetFromMistraDictionary:(NSDictionary*)mistraDictionary
{
    NSSet * jsonSet = [self setFromMistraJson:mistraDictionary];
    
    NSPredicate * articlesPredicate = [NSPredicate predicateWithFormat:@"SELF['type'] == 'categorie'"];
    
    return [jsonSet filteredSetUsingPredicate:articlesPredicate];
}

+ (NSSet*) setFromMistraJson:(NSDictionary*)json
{
    NSMutableSet * set = [NSMutableSet set];
    
    for (NSDictionary * currentObject in json[@"formation"])
    {
        [set addObjectsFromArray:[[self decomposeJson:currentObject] allObjects]];
    }
    for (NSDictionary * currentObject in json[@"tutoriels"])
    {
        [set addObjectsFromArray:[[self decomposeJson:currentObject] allObjects]];
    }
    return [set copy];
}

+ (NSMutableSet*) decomposeJson:(NSDictionary*)json
{
    NSMutableSet * set = [NSMutableSet set];
    if ([json[@"content"] isKindOfClass:[NSDictionary class]])
    {
        [set addObject:json];
        [set addObjectsFromArray:[[self decomposeJson:json[@"content"]] allObjects]];
    }
    else if ([json[@"content"] isKindOfClass:[NSArray class]])
    {
        for (NSDictionary * contentDictionnary in json[@"content"])
        {
            [set addObject:json];
            [set addObjectsFromArray:[[self decomposeJson:contentDictionnary] allObjects]];
        }
    }
    else
    {
        [set addObject:json];
    }
    return set;
}

- (void)sendQuoteRequestWithQuote:(MistraQuote*)quote
{
    [Flurry logEvent:@"Quote Request Sending"];
    [self.quoteSessionManager GET:@"index.php?option=com_aicontactsafe"
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, ONOXMLDocument * responseObject)
    {
        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
        NSArray * array = @[@"aics_Formations_", @"aics_name", @"aics_phone", @"aics_email", @"aics_Ville_souhaite", @"aics_Socit", @"aics_message", @"current_url"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", array];
        [responseObject enumerateElementsWithXPath:@"//form[@id=\"adminForm_4\"]//input" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop)
         {
             if (element[@"name"] && [predicate evaluateWithObject:element[@"name"]] && element[@"value"])
             {
                 [parameters setObject:element[@"value"] forKey:element[@"name"]];
             }
         }];
        
        [parameters setObject:quote.subject forKey:@"aics_Formations_"];
        [parameters setObject:quote.name forKey:@"aics_name"];
        [parameters setObject:quote.phone forKey:@"aics_phone"];
        [parameters setObject:quote.email forKey:@"aics_email"];
        [parameters setObject:quote.city forKey:@"aics_Ville_souhaite"];
        [parameters setObject:quote.company forKey:@"aics_Socit"];
        [parameters setObject:quote.message forKey:@"aics_message"];
        [parameters setObject:@"https://www.mistra.fr/contacts" forKey:@"current_url"];
        
        [self.quoteSessionManager POST:@"index.php?option=com_aicontactsafe"
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject)
        {
            [Flurry logEvent:@"Quote Request Sent"];
            [quote destroy];
            [[MistraQuote appDelegate] saveUserContextWithCompletion:nil];
        }
                               failure:^(NSURLSessionDataTask *task, NSError *error)
        {
            [Flurry logEvent:@"Quote Request Failed"];
            [error displayLocalizedError];
        }];
    }
                          failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [Flurry logEvent:@"Quote Request Failed"];
        [error displayLocalizedError];
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
