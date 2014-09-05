//
//  ContactTableViewCell.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 02/09/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactDetailTextLabel;


@end

@implementation ContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UILabel *)textLabel
{
    return self.contactTextLabel;
}

- (UILabel *)detailTextLabel
{
    return self.contactDetailTextLabel;
}

- (UIImageView *)imageView
{
    return self.contactImageView;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
