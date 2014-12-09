//
//  BlogTableViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 14/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "BlogTableViewController.h"
#import "BlogContentViewController.h"
#import "NSError+Display.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <BTUtils/GTMNSString+HTML.h>
#import <FlurrySDK/Flurry.h>

@interface BlogTableViewController () <UISearchDisplayDelegate>

@property (copy, nonatomic) NSArray * content;
@property (copy, nonatomic) NSArray * searchResults;

@end

@implementation BlogTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    self.content = [MistraHelper helper].rssBlogContent;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rssUpdateSucceededWithNotification:)
                                                 name:kMistraHelperRSSFeedUpdatedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rssUpdateFailedWithNotification:)
                                                 name:kMistraHelperRSSFeedUpdateFailedNotification
                                               object:nil];
    
    [self startRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Blog Page" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Blog Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startRefresh
{
    [[MistraHelper helper] updateMistraRSSFeed];
}



#pragma mark - NSNotification methods
- (void)rssUpdateSucceededWithNotification:(NSNotification*)notification
{
    self.content = notification.object;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.refreshControl endRefreshing];
    self.title = @"Blog";
}

- (void)rssUpdateFailedWithNotification:(NSNotification*)notification
{
    [notification.object displayLocalizedError];
    [self.refreshControl endRefreshing];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate * searchPredicate = [NSPredicate predicateWithFormat:@"(SELF.title contains[cd] %@) OR (SELF.content contains[cd] %@)", searchString, searchString];
    self.searchResults = [self.content filteredArrayUsingPredicate:searchPredicate];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchResults = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray * targetArray;
    if (tableView == self.tableView)
    {
        targetArray = self.content;
    }
    else
    {
        targetArray = self.searchResults;
    }
    return targetArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray * targetArray;
    if (tableView == self.tableView)
    {
        targetArray = self.content;
    }
    else
    {
        targetArray = self.searchResults;
    }
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
    
    RSSItem * item = targetArray[indexPath.row];
    
    cell.textLabel.text = item.title;
    NSString * detail = item.itemDescription.gtm_stringByUnescapingFromHTML;
    detail = [detail stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    detail = [detail stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    cell.detailTextLabel.text = detail;
    
    
    // Clean l'image residuelle
    cell.imageView.image = [UIImage imageNamed:@"no_image"];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:item.imagesFromContent.firstObject]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToBlogContentViewController"])
    {
        RSSItem * selectedItem;
        if (self.searchDisplayController.active)
        {
            NSIndexPath * indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            selectedItem = self.searchResults[indexPath.row];
        }
        else
        {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            selectedItem = self.content[indexPath.row];
        }
        BlogContentViewController * destination = segue.destinationViewController;
        destination.content = selectedItem;
    }
}

@end
