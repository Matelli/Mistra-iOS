//
//  ContentViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 08/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "ContentViewController.h"
#import "QuoteRequestViewController.h"
#import "MenuTableViewController.h"

@interface ContentViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    [self.webView loadHTMLString:[[NSString alloc] initWithData:self.article.content encoding:NSUTF8StringEncoding] baseURL:[MistraHelper contentDirectoryURL]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Content Page" withParameters:@{@"id":self.article.itemID,
                                                      @"title": self.title} timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Content Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.webView.delegate = self;
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        return YES;
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURLComponents * urlComponents = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:YES];
        if ([urlComponents.scheme isEqualToString:@"file"])
        {
            if ([urlComponents.path.lastPathComponent isEqualToString:@"contacts"])
            {
                [self performSegueWithIdentifier:@"ToQuoteRequestViewController" sender:nil];
            }
            else if ([urlComponents.path.lastPathComponent isEqualToString:@"index.php"])
            {
                NSArray * parametersArray = [urlComponents.query componentsSeparatedByString:@"&"];
                NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
                for (NSString * parameter in parametersArray)
                {
                    NSRange equalPosition = [parameter rangeOfString:@"="];
                    [parameters setObject:[parameter substringFromIndex:equalPosition.location+1] forKey:[parameter substringToIndex:equalPosition.location]];
                    if (parameters[@"id"])
                    {
                        NSString * idParam = parameters[@"id"];
                        if ([idParam rangeOfString:@":"].location != NSNotFound)
                        {
                            [parameters setObject:[idParam substringToIndex:[idParam rangeOfString:@":"].location] forKey:@"id"];
                        }
                    }
                }
                if ([parameters[@"view"] isEqualToString:@"article"])
                {
                    MistraArticle * articleToDisplay = [MistraHelper articleWithID:[parameters[@"id"] unsignedIntegerValue]];
                    UIStoryboard *storyboard;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
                    }
                    else
                    {
                        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
                    }
                    
                    ContentViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
                    
                    dest.article = articleToDisplay;
                    dest.title = articleToDisplay.title;
                    
                    [self.navigationController pushViewController:dest animated:YES];
                }
                else if ([parameters[@"view"] isEqualToString:@"category"])
                {
                    MistraCategory * categoryToDisplay = [MistraHelper categoryWithID:[parameters[@"id"] unsignedIntegerValue]];
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
                    
                    dest.items = [categoryToDisplay allObjects];
                    dest.title = categoryToDisplay.title;
                    
                    [self.navigationController pushViewController:dest animated:YES];
                }
            }
        }
        else
        {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
    }
    return NO;
}

- (IBAction)share:(id)sender
{
    NSURL * shareURL = [MistraHelper urlForArticleWithID:[self.article.itemID unsignedIntegerValue]];
    UIActivityViewController * activityViewcontroller = [[UIActivityViewController alloc] initWithActivityItems:@[shareURL] applicationActivities:nil];
    [self presentViewController:activityViewcontroller animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ToQuoteRequestViewController"])
    {
        QuoteRequestViewController * destination = segue.destinationViewController;
        destination.articleTitle = self.article.title;
    }
}


@end
