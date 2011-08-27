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
#import "Ente.h"
#import "CargoEnteSerie.h"
#import "CargoCell.h"
#import "EnteDetailsController.h"

@implementation SerieDetailsController

@class AUnder;

@synthesize codigoSerie;
@synthesize numeroCapitulos;
@synthesize nombreEstudio;
@synthesize generos;
@synthesize sinopsis;
@synthesize imagen;
@synthesize scroll;
@synthesize precuelaView;
@synthesize precuelaTitulo;
@synthesize precuelaImagen;
@synthesize secuelaView;
@synthesize secuelaTitulo;
@synthesize secuelaImagen;
@synthesize pageControl;
@synthesize enteScroll;

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
    [enteScroll release];
    [pageControl release];
    
    [precuelaView release];
    [precuelaTitulo release];
    [precuelaImagen release];
    [secuelaView release];
    [secuelaTitulo release];
    [secuelaImagen release];
    
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
    
    // formateo de entes
    
    self.enteScroll.delegate = self;
    
    int idx = 0;
    
    CGFloat contentOffset = 0.0f;

    for (CargoEnteSerie *ces in serie.staff) {
        NSLog(@"Cargo: %@ Ente %@ Capitulos %d",ces.cargo,ces.ente.nick,ces.capitulos);

        CGRect rect = CGRectMake(contentOffset, 0, self.enteScroll.frame.size.width, self.enteScroll.frame.size.height);

        
        CargoCell *cargo = [[[CargoCell alloc]initWithFrame:rect]retain];
        cargo.scrollView = self.enteScroll;
        cargo.detailsController = self;
        cargo.theIndex = idx;
        
        cargo.nombreLabel.text = ces.ente.nick;
        cargo.cargoLabel.text = [NSString stringWithFormat:@"%d capítulos como:\n%@",ces.capitulos,ces.cargo];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *urlAvatar = [NSURL URLWithString: [[ces.ente avatar]retain]]; 
            UIImage *imageAvatar = [[UIImage imageWithData: [NSData dataWithContentsOfURL: urlAvatar]] retain];
            dispatch_async(dispatch_get_main_queue(), ^{
                cargo.avatarImage.image = imageAvatar; 
            });
        });
        
        [self.enteScroll addSubview:cargo];
        
        // TODO añadir soporte al tap en la celda para mostrar la información del ente
        
        contentOffset += rect.size.width;
        self.enteScroll.contentSize = CGSizeMake(contentOffset,self.enteScroll.frame.size.height);

        idx++;
    }
    
    // reorganización de la ventana
    
    [self.sinopsis sizeToFit];
        
    if (serie.precuela!=nil && serie.secuela!=nil) {
        // tiene precuela y secuela
        
        [precuelaView setFrame:CGRectMake(0, (sinopsis.frame.origin.y+sinopsis.frame.size.height)+5, precuelaView.frame.size.width, precuelaView.frame.size.height)];
        [secuelaView setFrame:CGRectMake(0, (precuelaView.frame.origin.y+precuelaView.frame.size.height)+5, secuelaView.frame.size.width, secuelaView.frame.size.height)];
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, (secuelaView.frame.origin.y+sinopsis.frame.size.height));
        
        precuelaTitulo.text = [[serie precuela]nombre];
        secuelaTitulo.text = [[serie secuela]nombre];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *urlPrecuela = [NSURL URLWithString: [[[serie precuela] imagen]retain]]; 
            UIImage *imagePrecuela = [[UIImage imageWithData: [NSData dataWithContentsOfURL: urlPrecuela]] retain];
            
            
            NSURL *urlSecuela = [NSURL URLWithString: [[[serie secuela] imagen]retain]]; 
            UIImage *imageSecuela = [[UIImage imageWithData: [NSData dataWithContentsOfURL: urlSecuela]] retain];
            dispatch_async(dispatch_get_main_queue(), ^{
                [precuelaImagen setImage:imagePrecuela forState:UIControlStateNormal];
                [secuelaImagen setImage:imageSecuela forState:UIControlStateNormal];
            });

        });

        
    } else if (serie.precuela!=nil) {
        // tiene solo precuela
        [secuelaView removeFromSuperview];
        [precuelaView setFrame:CGRectMake(0, (sinopsis.frame.origin.y+sinopsis.frame.size.height)+5, precuelaView.frame.size.width, precuelaView.frame.size.height)];
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, (precuelaView.frame.origin.y+precuelaView.frame.size.height));
        precuelaTitulo.text = [[serie precuela]nombre];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *urlPrecuela = [NSURL URLWithString: [[[serie precuela] imagen]retain]]; 
            UIImage *imagePrecuela = [[UIImage imageWithData: [NSData dataWithContentsOfURL: urlPrecuela]] retain];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [precuelaImagen setImage:imagePrecuela forState:UIControlStateNormal];
            });
            
        });

    } else if (serie.secuela!=nil) {
        // tiene solo secuela
        [precuelaView removeFromSuperview];
        [secuelaView setFrame:CGRectMake(0, (sinopsis.frame.origin.y+sinopsis.frame.size.height)+5, secuelaView.frame.size.width, secuelaView.frame.size.height)];
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, (secuelaView.frame.origin.y+secuelaView.frame.size.height));
        secuelaTitulo.text = [[serie secuela]nombre];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            NSURL *urlSecuela = [NSURL URLWithString: [[[serie secuela] imagen]retain]]; 
            UIImage *imageSecuela = [[UIImage imageWithData: [NSData dataWithContentsOfURL: urlSecuela]] retain];
            dispatch_async(dispatch_get_main_queue(), ^{
                [secuelaImagen setImage:imageSecuela forState:UIControlStateNormal];
            });
            
        });
        
    } else {
        // forever alone
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, (sinopsis.frame.origin.y+sinopsis.frame.size.height));
        [precuelaView removeFromSuperview];
        [secuelaView removeFromSuperview];
    }
}

- (void)cellWasSelected:(CargoCell *)cell {
    NSLog(@"Celda seleccionada");
    CargoEnteSerie *ces = [serie.staff objectAtIndex:cell.theIndex];
    NSLog(@"Cargo: %@ Ente %@ Capitulos %d",ces.cargo,ces.ente.nick,ces.capitulos);
    
    EnteDetailsController *edc = [[[EnteDetailsController alloc] initWithEnteId:ces.ente.codigo]autorelease];
    [self.navigationController pushViewController:edc animated:YES];
}


- (void)cellWasDoubleTapped:(CargoCell *)cell {
    NSLog(@"Celda doble tap");
    CargoEnteSerie *ces = [serie.staff objectAtIndex:cell.theIndex];
    NSLog(@"Cargo: %@ Ente %@ Capitulos %d",ces.cargo,ces.ente.nick,ces.capitulos);

}

- (IBAction)showPrecuela:(id)sender {
    Serie *s = [serie precuela];
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[s codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
    [sdc release];
}

- (IBAction)showSecuela:(id)sender {
    Serie *s = [serie secuela];
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[s codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
    [sdc release];
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
    self.precuelaView = nil;
    self.precuelaTitulo = nil;
    self.precuelaImagen = nil;
    self.secuelaView = nil;
    self.secuelaTitulo = nil;
    self.secuelaImagen = nil;
    self.enteScroll = nil;
    self.pageControl = nil;
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
