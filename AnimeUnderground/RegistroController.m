//
//  RegistroController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "RegistroController.h"
#import "AUnder.h"
#import "Foro.h"

@implementation RegistroController

@synthesize registrarseB;
@synthesize catcha;
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
    [self setTitle:@"Registro"];
    AUnder *aunder = [AUnder sharedInstance];
    Foro *foro = aunder.foro;
    NSString *url = @"http://foro.aunder.org/member.php";
    NSString *parametros = @"action=register&agree=OK";
    NSString *datos= [foro webPost: url : parametros];
    NSRange rangoABuscar = [datos rangeOfString:@"imagehash="];
    NSRange rangoAux = [datos rangeOfString:@"\" alt=\"Verificaci"];
    rangoABuscar.length = rangoAux.location-rangoABuscar.location;
    
    NSString *imagehash = [datos substringWithRange:rangoABuscar];
    // http://foro.aunder.org/member.php?action=register&step=agreement&agree=Estoy%20de%20acuerdo
    NSString *imageURL = @"http://foro.aunder.org/captcha.php?action=regimage&";
    imageURL = [imageURL stringByAppendingString:imagehash];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *myimage = [[UIImage alloc] initWithData:mydata];
    catcha.image = myimage;
    [myimage release];

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

-(IBAction) postRegistrarse {
    [registrarseB setColor: [UIColor orangeColor]];
}

-(IBAction) registrarse {
    [registrarseB setColor: [UIColor orangeColor]];
    //TODO mandar registro a AU accion do_login y que sea lo que dios quiera.
}
@end
