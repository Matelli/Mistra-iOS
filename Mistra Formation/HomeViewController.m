//
//  HomeViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 08/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuTableViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *trainingButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;

@end

@implementation HomeViewController

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
    
    [[MistraHelper helper] updateContentWithCompletionHandler:nil];
    
    self.tutorialButton.enabled = YES;
    self.trainingButton.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Home Page" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Home Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTraining
{
    [self performSegueWithIdentifier:@"ToMenuTableViewController" sender:@{@"title":@"Formations",
                                                                           @"contentType":kMistraHelperContentTypeTraining}];
}

- (IBAction)showTutorial
{
    [self performSegueWithIdentifier:@"ToMenuTableViewController" sender:@{@"title":@"Tutoriels",
                                                                           @"contentType":kMistraHelperContentTypeTutorial}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToMenuTableViewController"])
    {
        MenuTableViewController * destination = segue.destinationViewController;
        destination.title = sender[@"title"];
        destination.contentType = sender[@"contentType"];
    }
}


@end
