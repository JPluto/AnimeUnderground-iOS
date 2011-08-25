//
//  LoginViewController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "LoginViewController.h"
#import "Foro.h"
#import "AUnder.h"

@implementation LoginViewController

@synthesize usuario,pass,loginB,registroB;

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
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *image = [UIImage imageNamed: @"logo_barra_au.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];    
	self.navigationItem.titleView = imageView;
    [loginB setColor:[UIColor orangeColor]];
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
-(IBAction) preLogin {
    [loginB setColor: [UIColor redColor]];
}
-(IBAction) preRegistro {
    [registroB setColor: [UIColor redColor]];
}
-(IBAction) login {
    [loginB setColor: [UIColor orangeColor]];
    AUnder *aunder = [AUnder sharedInstance];
    Foro *foro = aunder.foro;
    if (usuario.text != nil) {
        foro.user = usuario.text;
        [[NSUserDefaults standardUserDefaults] setValue:foro.user forKey:@"usuarioLogin_preference"];
    }
    if (pass.text != nil) {
        foro.pass = pass.text;
        [[NSUserDefaults standardUserDefaults] setValue:foro.pass forKey:@"passwordLogin_preference"];
    }
    BOOL isOK = [foro doLogin];
    if (!isOK) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Error"
                                   message: @"El par usuario/contraseña es invalido,\nno se ha podido hacer login."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(IBAction) registrarse{
    [registroB setColor: [UIColor orangeColor]];
    //TODO
}
@end
