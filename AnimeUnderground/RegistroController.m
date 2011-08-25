//
//  RegistroController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "RegistroController.h"


@implementation RegistroController

@synthesize registrarseB;
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
    [registrarseB setColor: [UIColor orangeColor]];
    UIImage *image = [UIImage imageNamed: @"logo_barra_au.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];    
	self.navigationItem.titleView = imageView;
    // TODO llamar a la pagina de registro con accion login para que devuelva la direccion del CATCHA
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
    [registrarseB setColor: [UIColor redColor]];
}

-(IBAction) registrarse {
    [registrarseB setColor: [UIColor orangeColor]];
    //TODO mandar registro a AU accion do_login y que sea lo que dios quiera.
}
@end
