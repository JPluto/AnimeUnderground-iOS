//
//  SeriesController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 08/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "SeriesController.h"
#import "Serie.h"
#import "Imagen.h"
#import "DeviantDownload.h"
#import "MMGridViewDefaultCell.h"
#import "UIImage+Resize.h"
#import "SliderPageControl.h"


@implementation SeriesController
@class AUnder,SerieDetailsController;
@synthesize gridView, nombreSerie, sliderPageControl, datosSerie, imagenSerie;

- (void)dealloc
{
    [nombreSerie release];
    [sliderPageControl release];
    [datosSerie release];
    [imagenSerie release];
    [gridView release];
    [downloads release];
    [forLazyLoading release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Series";
    
    downloads = [[[NSMutableArray alloc]init]retain];
    int size = [[[AUnder sharedInstance]series]count];
    forLazyLoading = [[[NSMutableArray alloc]initWithCapacity:size]retain];
    
    
    // iniciamos lazy loading de imágenes
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (Serie *s in [[AUnder sharedInstance] series]) {
            DeviantDownload *dd = [[DeviantDownload alloc]init];
            dd.urlString = [[s imagen] retain];
            [downloads addObject: [dd retain]];
        }
        Serie *rndSerie = nil;
        do {
            int randomSerie = arc4random() % size;
            rndSerie = [[[[AUnder sharedInstance] series]objectAtIndex:randomSerie]retain];
            randomSerieIndex = randomSerie;
        } while (![rndSerie isRecomendable]);
        
        NSURL *url = [NSURL URLWithString: [[rndSerie imagenBoton]retain]]; 
        UIImage *image = [[UIImage imageWithData: [NSData dataWithContentsOfURL: url]] retain];
                
        dispatch_async(dispatch_get_main_queue(), ^{
            [nombreSerie setText:[[rndSerie nombre]retain]];
            [imagenSerie setImage:image];
            [datosSerie setText:[[NSString alloc] initWithFormat:@"%@ - %d eps - %@",[rndSerie getGenerosString],[rndSerie capitulosTotales],[rndSerie estudio]]];
        });
        
        
                            
    });

    // iniciar el slider
    self.sliderPageControl = [[SliderPageControl alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
    [self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderPageControl setDelegate:self];
    [self.sliderPageControl setShowsHint:YES];
    [self.view addSubview:self.sliderPageControl];
    [self.sliderPageControl release];
    [self.sliderPageControl setNumberOfPages:[[[AUnder sharedInstance]series] count]];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    [self setupGridPages];
}

-(IBAction) showRandomSerieDetails {
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:randomSerieIndex];
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[s codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.gridView = nil;
    self.nombreSerie = nil;
    self.sliderPageControl = nil;
    self.datosSerie = nil;
    self.imagenSerie = nil;
}

- (void)setupGridPages {
    [sliderPageControl setNumberOfPages:gridView.numberOfPages];
    [sliderPageControl setCurrentPage:gridView.currentPageIndex animated:YES];
}

- (void)onPageChanged:(id)sender
{
	pageControlUsed = YES;
    [gridView moveToPage:sliderPageControl.currentPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [[[AUnder sharedInstance]series] count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull] autorelease];
    Serie *s = [[[AUnder sharedInstance]series]objectAtIndex:index];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", s.nombre];
    
    DeviantDownload *download = [downloads objectAtIndex:index];
    
    UIImage *imagen = download.image;
    if (imagen == nil) {
        imagen = [UIImage imageNamed:@"icono.png"];
        download.delegate = self;
    }
    
    [forLazyLoading insertObject:cell.backgroundView atIndex:index];
    
    // creamos el thumb de tamaño adecuado
    
    UIImage *tmp = [imagen resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(155, 105) interpolationQuality:kCGInterpolationMedium];
    
    
    cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:tmp];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:index];
    NSLog(@"serie elegida = %@",s.nombre);
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[s codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
    [sdc release];
}


- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
    NSLog(@"Cambio de página a %d",index);
    [self setupGridPages];
}

- (void)downloadDidFinishDownloading:(DeviantDownload *)download {
    
    NSUInteger index = [downloads indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    
    UIView *vista = [forLazyLoading objectAtIndex:index];
    
    UIImage *tmp = [[download image] resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(155, 105) interpolationQuality:kCGInterpolationMedium];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        vista.backgroundColor = [UIColor colorWithPatternImage:tmp];

    });
    
    [path release];
    download.delegate = nil;
}

@end
