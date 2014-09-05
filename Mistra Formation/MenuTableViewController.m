//
//  MenuTableViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 07/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ContentViewController.h"
#import "MenuHeaderTableViewCell.h"

@interface MenuTableViewController () <UISearchDisplayDelegate>

@property (copy, nonatomic) NSArray * searchResults;

@end

@implementation MenuTableViewController

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
    
    if (!self.items && self.contentType)
    {
        [self loadContentForType:self.contentType];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshContent)
                                                 name:kMistraDatabaseUpdatedNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"List Page" withParameters:@{@"title": self.title} timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"List Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (NSArray*)contentForSearchText:(NSString*)searchText
{
    return [MistraHelper articlesForSearchString:searchText inContentType:self.contentType];
}

- (void)refreshContent
{
    if (!self.parentCategoryID && self.contentType)
    {
        [self loadContentForType:self.contentType];
        [self.tableView reloadData];
    }
    else if (self.parentCategoryID)
    {
        MistraCategory * parentCategory = [MistraHelper categoryWithID:self.parentCategoryID.unsignedIntegerValue];
        self.items = [parentCategory.categories.array arrayByAddingObjectsFromArray:parentCategory.articles.array];
        [self.tableView reloadData];
    }
    if (self.searchResults)
    {
        self.searchResults = [self contentForSearchText:self.searchDisplayController.searchBar.text];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)loadContentForType:(NSString*)contentType
{
    self.items = [MistraHelper contentForType:contentType];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    id target;
    if (tableView == self.tableView)
    {
        target = self.items;
    }
    else
    {
        target = self.searchResults;
    }
    return [target count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id target;
    if (tableView == self.tableView)
    {
        target = self.items;
    }
    else
    {
        target = self.searchResults;
    }
    // Return the number of rows in the section.
    if ([target[section] isKindOfClass:[MistraCategory class]])
    {
        return [target[section] count];
    }
    else
    {
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id target;
    if (tableView == self.tableView)
    {
        target = self.items;
    }
    else
    {
        target = self.searchResults;
    }
    if ([target[section] isMemberOfClass:[MistraArticle class]])
    {
        return nil;
    }
    else
    {
        MenuHeaderTableViewCell * header = [self.tableView dequeueReusableCellWithIdentifier:@"headerView"];
        header.headerLabel.text = [[NSAttributedString alloc] initWithData:[[target[section] title] dataUsingEncoding:NSUnicodeStringEncoding]
                                                                   options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                        documentAttributes:nil
                                                                     error:nil
                                   ].string;
        
        return header;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id target;
    if (tableView == self.tableView)
    {
        target = self.items;
    }
    else
    {
        target = self.searchResults;
    }
    if ([target[section] isMemberOfClass:[MistraArticle class]])
    {
        return 0;
    }
    else
    {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id target;
    if (tableView == self.tableView)
    {
        target = self.items;
    }
    else
    {
        target = self.searchResults;
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ([target[indexPath.section] isMemberOfClass:[MistraArticle class]])
    {
        cell.textLabel.text = [target[indexPath.section] title];
    }
    else
    {
        cell.textLabel.text = [target[indexPath.section][indexPath.row] title];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id target;
    if (tableView == self.tableView)
    {
        target = self.items;
    }
    else
    {
        target = self.searchResults;
    }
    MistraItem * selectedObject;
    if ([target[indexPath.section] isMemberOfClass:[MistraArticle class]])
    {
        selectedObject = target[indexPath.section];
    }
    else
    {
        selectedObject = target[indexPath.section][indexPath.row];
    }
    
    
    if ([selectedObject isMemberOfClass:[MistraCategory class]])
    {
        UIStoryboard *storyboard;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        }
        else
        {
            storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }
        
        MenuTableViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"MenuTableViewController"];
        
        dest.items = [(MistraCategory*)selectedObject allObjects];
        dest.title = [selectedObject title];
        dest.parentCategoryID = selectedObject.itemID;
        
        [self.navigationController pushViewController:dest animated:YES];
    }
    else if ([selectedObject isMemberOfClass:[MistraArticle class]])
    {
        [self performSegueWithIdentifier:@"ToContentViewController" sender:selectedObject];
    }
}

#pragma mark - UISearchDisplayDelegate

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchResultsTableView.backgroundColor = self.tableView.backgroundColor;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchResults = [self contentForSearchText:searchString];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchResults = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToContentViewController"])
    {
        MistraArticle * selectedObject = sender;
        ContentViewController * destination = segue.destinationViewController;
        
        destination.article = selectedObject;
        destination.title = selectedObject.title;
    }
}


@end
