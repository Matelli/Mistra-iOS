//
//  MenuHeaderTableViewCell.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 20/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "MenuHeaderTableViewCell.h"

@implementation MenuHeaderTableViewCell

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

@end
