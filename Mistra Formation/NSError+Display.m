//
//  NSError+Display.m
//  PicFire
//
//  Created by Florian BUREL on 20/02/2014.
//  Copyright (c) 2014 Florian BUREL. All rights reserved.
//

#import "NSError+Display.h"

@implementation NSError (Display)

- (void) displayLocalizedError
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:self.localizedDescription
                                                    message:self.localizedRecoverySuggestion
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    
    [alert show];
    
}
@end
