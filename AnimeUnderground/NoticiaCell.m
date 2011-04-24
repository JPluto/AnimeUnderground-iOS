//
//  NoticiaCell.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 24/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "NoticiaCell.h"


@implementation NoticiaCell

@synthesize imagen;
@synthesize titulo;
@synthesize autor;
@synthesize fecha;
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

- (void)dealloc
{
    [super dealloc];
}

@end
