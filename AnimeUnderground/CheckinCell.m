//
//  CheckinCell.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 01/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "CheckinCell.h"


@implementation CheckinCell

@synthesize numero,check;

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
