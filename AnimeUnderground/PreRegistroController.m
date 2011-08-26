//
//  PreRegistroController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 26/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "PreRegistroController.h"
#import "RegistroController.h"


@implementation PreRegistroController

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
    self.title = @"Acuerdo de Registro";
    [registroB setColor:[UIColor orangeColor]];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction) preRegistrarse {
    [registroB setColor: [UIColor redColor]];
}

-(IBAction) postRegistrarse {
    [registroB setColor: [UIColor orangeColor]];
} 

-(IBAction) registrar {

        [registroB setColor: [UIColor orangeColor]];
        RegistroController *rc = [[RegistroController alloc] init];
        [self.navigationController pushViewController: rc animated:YES];
        [rc release];

}

@end
