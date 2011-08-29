//
//  EnteCell.m
//  AnimeUnderground
//
//  Created by Nacho L. on 29/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "EnteCell.h"

@implementation EnteCell

@synthesize imagenAvatar;
@synthesize nickEnte;
@synthesize loading;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
