//
//  EnteDetailsController.m
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnteDetailsController.h"
#import "Ente.h"


@implementation EnteDetailsController

@class AUnder;
@synthesize enteNick;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEnteId:(int)enteId {
    self = [super init];
    if (self) {
        ente = [[[AUnder sharedInstance] getEnteById:enteId]retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ente release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = ente.nick;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
