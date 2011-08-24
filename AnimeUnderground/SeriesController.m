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
@synthesize gridView, nombreSerie, sliderPageControl;

- (void)dealloc
{
    [gridView release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Series";
    
    downloads = [[[NSMutableArray alloc]init]retain];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (Serie *s in [[AUnder sharedInstance] series]) {
            DeviantDownload *dd = [[DeviantDownload alloc]init];
            dd.urlString = [[s imagen] retain];
            [downloads addObject: [dd retain]];
        }
                
        // habrá que añadir un loading al estilo de rootviewcontroller
        dispatch_async(dispatch_get_main_queue(), ^{
           //[carousel reloadData];
            currentSelection = 0;
        });       
    });

    
    self.sliderPageControl = [[SliderPageControl alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
    [self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderPageControl setDelegate:self];
    [self.sliderPageControl setShowsHint:YES];
    [self.view addSubview:self.sliderPageControl];
    [self.sliderPageControl release];
    [self.sliderPageControl setNumberOfPages:[[[AUnder sharedInstance]series] count]];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    //currentSelection = 0;
    //Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:0];
    //nombreSerie.text = s.nombre;
    [self setupGridPages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.gridView = nil;
}

- (void)setupGridPages {
    [sliderPageControl setNumberOfPages:gridView.numberOfPages];
    [sliderPageControl setCurrentPage:gridView.currentPageIndex animated:YES];
    
    //pageControl.numberOfPages = gridView.numberOfPages;
    //pageControl.currentPage = gridView.currentPageIndex;
}

- (void)onPageChanged:(id)sender
{
	pageControlUsed = YES;
    NSLog(@"Intento cambiar a la página %d",sliderPageControl.currentPage);
    [gridView.currentPageIndex: sliderPageControl.currentPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
    
    // creamos el thumb de tamaño adecuado
    
    UIImage *tmp2 = [imagen resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(155, 105) interpolationQuality:kCGInterpolationMedium];
    
    
    
    cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:tmp2];
    //[cell.backgroundView addSubview:imgView];
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
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}

/*
// reacción de la ui

-(IBAction) showSerieDetails {
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:currentSelection];
    NSLog(@"serie elegida = %@",s.nombre);
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[s codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
}

// -- a partir de aquí sobra

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[[AUnder sharedInstance]series] count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    //create a numbered view
    
    DeviantDownload *download = [downloads objectAtIndex:index];
    
    UIImage *imagen = download.image;
    if (imagen == nil) {
        imagen = [UIImage imageNamed:@"page.png"];
        download.delegate = self;
    }
    UIView *view = [[[UIImageView alloc] initWithImage:[self imageWithImage:imagen scaledToSize:CGSizeMake(200, 200)]] autorelease];

    currentSelection = index;
    
    //UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];

    return view;
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)car {
    int index = carousel.currentItemIndex;
    currentSelection = index;
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:index];
    nombreSerie.text = s.nombre;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 200;
}

- (CATransform3D)carousel:(iCarousel *)carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)car
{
    //wrap all carousels
    return NO;
}

*/

@end
