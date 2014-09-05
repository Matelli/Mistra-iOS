//
//  BlogTableViewCell.m
//  Mistra Formation
//
//  Created by Jonathan Schmidt on 21/08/2014.
//  Copyright (c) 2014 Mistra. All rights reserved.
//

#import "BlogTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation BlogTableViewCell

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

- (void)prepareForReuse
{
    [self.imageView cancelImageRequestOperation];
    [super prepareForReuse];
}

- (UIImageView *)imageView
{
    return self.blogImageView;
}

- (UILabel *)textLabel
{
    return self.blogTextLabel;
}

- (UILabel *)detailTextLabel
{
    return self.blogDetailTextLabel;
}

@end
