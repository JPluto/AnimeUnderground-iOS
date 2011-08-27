//
//  EnteDetailsController.m
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnteDetailsController.h"
#import "Ente.h"
#import "MMGridViewDefaultCell.h"
#import "CargoEnteSerie.h"
#import "DeviantDownload.h"
#import "SerieDetailsController.h"

@implementation EnteDetailsController

@class AUnder;
@synthesize estado;
@synthesize avatar;
@synthesize subnick;
@synthesize datosExtra;
@synthesize gridView;

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
    [datosExtra release];
    [subnick release];
    [estado release];
    [avatar release];
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
    
    if (ente.activo) 
        self.estado.text = @"Ente activo";
    else
        self.estado.text = @"Ente inactivo / Ex-miembro";

    self.subnick.text = ente.titulo;
    self.datosExtra.text = [NSString stringWithFormat:@"%@ - %d años - %@",ente.sexo,ente.edad,ente.ciudad];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *urlAvatar = [NSURL URLWithString: ente.avatar]; 
        UIImage *imageAvatar = [[UIImage imageWithData: [NSData dataWithContentsOfURL: urlAvatar]] retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.avatar setImage:imageAvatar];
            [imageAvatar release];
        });

    });
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.avatar = nil;
    self.estado = nil;
    self.subnick = nil;
    self.datosExtra = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [[ente cargos]count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull] autorelease];
    
    CargoEnteSerie *s = [[ente cargos]objectAtIndex:index];
    cell.textLabel.text = s.cargo;
        
    //[forLazyLoading insertObject:cell.backgroundView atIndex:index];
    //[forLazySpinners insertObject:cell.loadingView atIndex:index];
    
    // creamos el thumb de tamaño adecuado
    
    //UIImage *tmp = [imagen resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(155, 105) interpolationQuality:kCGInterpolationMedium];
    
    
    //cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:tmp];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    CargoEnteSerie *s = [[ente cargos]objectAtIndex:index];
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[[s serie]codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
    [sdc release];
}


- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
    NSLog(@"Cambio de página a %d",index);
    //[self setupGridPages];
}


@end
