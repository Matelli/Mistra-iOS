//
//  ContactViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 02/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "ContactViewController.h"
#import "MistraFormationAppearance.h"

@interface ContactViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;

@end

@implementation ContactViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.footerImageView.image = [[UIImage imageNamed:@"splash-bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,0,0,0) resizingMode:UIImageResizingModeStretch];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Contact Page" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Contact Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addressClick:(id)sender
{
    [MistraHelper openAddress];
}

- (IBAction)phoneClicked:(id)sender
{
    [MistraHelper openPhone];
}

- (IBAction)emailClicked:(id)sender
{
    [MistraHelper openEmailFromViewController:self];
}

- (IBAction)facebookClicked:(id)sender
{
    [MistraHelper openFacebook];
}

- (IBAction)twitterClicked:(id)sender
{
    [MistraHelper openTwitter];
}

- (IBAction)googlePlusClicked:(id)sender
{
    [MistraHelper openGooglePlus];
}

- (IBAction)linkedInClicked:(id)sender
{
    [MistraHelper openLinkedIn];
}

- (IBAction)viadeoClicked:(id)sender
{
    [MistraHelper openViadeo];
}

- (IBAction)stackOverflowClicked:(id)sender
{
    [MistraHelper openStackOverflow];
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"Adresse";
            cell.detailTextLabel.text = @"19 rue Bérangers, 75003 Paris";
            cell.imageView.image = [UIImage imageNamed:@"ico_adresse_contact"];
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = @"Téléphone";
            cell.detailTextLabel.text = @"01 82 52 25 25";
            cell.imageView.image = [UIImage imageNamed:@"ico_phone_contact"];
            break;
        }
            
        case 2:
        {
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = @"formation@mistra.fr";
            cell.imageView.image = [UIImage imageNamed:@"ico_mail_contact"];
            break;
        }
            
        default:
            break;
    }
    cell.textLabel.font = [MistraFormationAppearance fontForContactLabel];
    
    cell.detailTextLabel.font = [MistraFormationAppearance fontForContactDetail];
    cell.detailTextLabel.textColor = [MistraFormationAppearance colorForContactCellDetailText];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            [self addressClick:nil];
            break;
        }
        
        case 1:
        {
            [self phoneClicked:nil];
            break;
        }
        
        case 2:
        {
            [self emailClicked:nil];
            break;
        }
        default:
            break;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
