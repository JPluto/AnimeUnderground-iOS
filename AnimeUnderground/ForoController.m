//
//  ForoController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 30/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "ForoController.h"


@implementation ForoController

@synthesize webView, urlString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [urlString release];
    [webView release];
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
    
    [self setTitle:@"Foro"];
    
    NSURL *url = [NSURL URLWithString:@"http://foro.aunder.org"];
    if (urlString!=nil)
        if (![urlString isEqualToString:@""])
            url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:url];	
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:30];
    
    [webView loadRequest:request];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Anterior" style:UIBarButtonItemStyleBordered target:nil action:@selector(goBack)];
	self.navigationItem.rightBarButtonItem = anotherButton;
	[anotherButton release];
}

- (void)goBack {
    [webView goBack];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
