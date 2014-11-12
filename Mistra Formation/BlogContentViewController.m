//
//  BlogContentViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 14/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "BlogContentViewController.h"
#import <FlurrySDK/Flurry.h>

@interface BlogContentViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BlogContentViewController

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
    
    self.title = self.content.title;
    self.webView.delegate = self;
    [self.webView loadHTMLString:[self.content.content stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"https://"] baseURL:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Blog Content Page" withParameters:@{@"title": self.content.title} timed:YES];
    UIBarButtonItem * shareButtonItem;
    shareButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Blog Content Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.webView.delegate = nil;
}

- (IBAction)share:(id)sender
{
    NSURL * shareURL = self.content.link;
    NSString * title = self.content.title;
    
    UIActivityViewController * activityViewcontroller = [[UIActivityViewController alloc] initWithActivityItems:@[title, shareURL] applicationActivities:nil];
    [self presentViewController:activityViewcontroller animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        return YES;
    }
    else
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
}
@end
