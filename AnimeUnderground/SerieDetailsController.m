//
//  SerieDetailsController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 05/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "SerieDetailsController.h"
#import "DeviantDownload.h"
#import "Serie.h"

@implementation SerieDetailsController

@class AUnder;

@synthesize codigoSerie;
@synthesize numeroCapitulos;
@synthesize nombreEstudio;
@synthesize generos;
@synthesize sinopsis;
@synthesize imagen;
@synthesize scroll;

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
    [scroll release];
    [imagen release];
    [numeroCapitulos release];
    [nombreEstudio release];
    [generos release];
    [sinopsis release];
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
    // Do any additional setup after loading the view from its nib.
    serie = [[AUnder sharedInstance]getSerieById:codigoSerie];
    self.title = [serie nombre];
    
    self.numeroCapitulos.text = [NSString stringWithFormat:@"%d/%d",[serie capitulosActuales],[serie capitulosTotales]];
    self.nombreEstudio.text = [serie estudio];
    self.generos.text = [serie getGenerosString];
    self.sinopsis.text = [serie sinopsis];
    self.sinopsis.numberOfLines = 0;
    DeviantDownload *dd = [[DeviantDownload alloc]init];
    dd.urlString = [serie imagen];
    self.imagen.image = [dd image];
    
    [self.sinopsis sizeToFit];
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, (sinopsis.frame.origin.y+sinopsis.frame.size.height));

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.numeroCapitulos = nil;
    self.nombreEstudio = nil;
    self.generos = nil;
    self.sinopsis = nil;
    self.imagen = nil;
    self.scroll = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)downloadDidFinishDownloading:(DeviantDownload *)download {
    self.imagen.image = [download image];
}

@end
