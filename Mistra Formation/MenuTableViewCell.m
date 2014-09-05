//
//  MenuTableViewCell.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 20/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MenuTableViewCell.h"

@interface MenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *menuCellTextLabel;

@end

@implementation MenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

#pragma mark - UITableViewCell override
- (UILabel *)textLabel
{
    return self.menuCellTextLabel;
}

@end
