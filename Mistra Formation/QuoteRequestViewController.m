//
//  QuoteRequestViewController.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 12/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "QuoteRequestViewController.h"
@import AddressBook;
@import AddressBookUI;

@interface QuoteRequestViewController () <UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextView *commentsField;
@property (weak, nonatomic) IBOutlet UIImageView *commentArrowImageView;

@property (assign, nonatomic) NSUInteger maxCharacters;

@property (assign, nonatomic) BOOL presentedRequest;

@end

@implementation QuoteRequestViewController

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
    
    self.commentArrowImageView.transform = CGAffineTransformRotate(self.commentArrowImageView.transform, M_PI_2);
    
    self.maxCharacters = 500;
    [self updateCharacterCount];
    
    self.subjectField.text = self.articleTitle;
    
    self.presentedRequest = NO;
    
    [self.commentsLabel setFont:[UIFont fontWithName:@"Neris-Thin" size:20.0f]];
    
    [self.commentsField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.2] CGColor]];
    [self.commentsField.layer setBorderWidth:1.0];
    self.commentsField.layer.cornerRadius = 5.0;
    self.commentsField.clipsToBounds = YES;
    
    if (!self.articleTitle)
    {
        self.articleTitle = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Quote Page" withParameters:@{@"title": self.articleTitle} timed:YES];
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (!self.presentedRequest && (status == kABAuthorizationStatusNotDetermined || status == kABAuthorizationStatusAuthorized))
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Remplir les champs automatiquement via un contact ?" message:@"" delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil];
        [alert show];
        self.presentedRequest = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"Quote Page" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateCharacterCount
{
    self.commentsLabel.text = [NSString stringWithFormat:@"Commentaires (%lu car.)", (unsigned long)self.maxCharacters - self.commentsField.attributedText.length];
}

- (IBAction)sendQuoteRequest:(id)sender
{
    if (!self.emailField.text.length)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Vous devez au moins spécifier une adresse email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        // Send Quote
        [[MistraHelper helper] sendQuoteRequestWithInformations:@{@"aics_Formation_":self.subjectField.text,
                                                                  @"aics_name":self.nameField.text,
                                                                  @"aics_phone":self.phoneField.text,
                                                                  @"aics_email":self.emailField.text,
                                                                  @"aics_Ville_souhaite":self.cityField.text,
                                                                  @"aics_Socit":self.companyField.text,
                                                                  @"aics_message":self.commentsField.text,
                                                                  @"send_mail":@"1"
                                                                  }];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    BOOL flurryUserDidRequestAutoFill = NO;
    if (buttonIndex > 0)
    {
        flurryUserDidRequestAutoFill = YES;
        // If we aren't authorized yet
        if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
        {
            // Request Access to the user's contacts
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error)
             {
                 if (granted)
                 {
                     [self selectContact];
                 }
                 else
                 {
                     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"L'accès à vos contact est requis pour le remplissage automatique" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                     [alert show];
                 }
             });
        }
        else
        {
            [self selectContact];
        }
    }
    [Flurry logEvent:@"QuoteRequest Autofill" withParameters:@{@"User-Requested": @(flurryUserDidRequestAutoFill)}];
}

- (void) selectContact
{
    // ???: Is it possible to try to find the "me" contact first before asking ? Or is the feature correct like that to allow someone to request a quote for someone else.
    ABPeoplePickerNavigationController * pickerController = [[ABPeoplePickerNavigationController alloc] init];
    pickerController.peoplePickerDelegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) fillFormWithContactDetails:(ABRecordRef)contact
{
    [Flurry logEvent:@"QuoteRequest Autofill success"];
    NSString * name = [NSString stringWithFormat:@"%@ %@",
                       (__bridge_transfer NSString*)ABRecordCopyValue(contact,
                                                                                                         kABPersonFirstNameProperty),
                       (__bridge_transfer NSString*)ABRecordCopyValue(contact,
                                                                                                                                                                                    kABPersonLastNameProperty)];
    self.nameField.text = name;
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(contact,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0)
    {
        self.phoneField.text = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    CFRelease(phoneNumbers);
    
    ABMultiValueRef emails = ABRecordCopyValue(contact,
                                               kABPersonEmailProperty);
    if (ABMultiValueGetCount(emails) > 0)
    {
        self.emailField.text = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(emails, 0);
    }
    CFRelease(emails);
    
    ABMultiValueRef addressRef = ABRecordCopyValue(contact, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addressRef) > 0)
    {
        NSDictionary *addressDict = (__bridge_transfer NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        
        self.cityField.text = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
    }
    CFRelease(addressRef);
    
    self.companyField.text = (__bridge_transfer NSString*)ABRecordCopyValue(contact,
                                                                            kABPersonOrganizationProperty);
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self fillFormWithContactDetails:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [Flurry logEvent:@"QuoteRequest Autofill cancelled"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > self.maxCharacters)
    {
        [Flurry logEvent:@"QuoteRequest User Overtyped"];
        textView.text = [textView.text stringByReplacingCharactersInRange:NSRangeFromString([NSString stringWithFormat:@"%lu,%lu", (unsigned long)self.maxCharacters,(unsigned long)textView.attributedText.length-self.maxCharacters]) withString:@""];
    }
    [self updateCharacterCount];
    
}

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
