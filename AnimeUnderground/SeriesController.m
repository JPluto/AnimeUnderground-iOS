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

@implementation SeriesController
@class AUnder;
@synthesize carousel, nombreSerie;

- (void)dealloc
{
    [carousel release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Series";
    
    downloads = [[[NSMutableArray alloc]init]retain];
    
    for (Serie *s in [[AUnder sharedInstance] series]) {
        DeviantDownload *dd = [[DeviantDownload alloc]init];
        dd.urlString = [[s imagen] retain];
        [downloads addObject: [dd retain]];
    }
    
    carousel.type = iCarouselTypeLinear;
    [carousel reloadData];
    
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:0];
    nombreSerie.text = s.nombre;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[[AUnder sharedInstance]series] count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    //create a numbered view
    DeviantDownload *download = [downloads objectAtIndex:index];
    NSLog(@"%i Quiero cargar %@",downloads.count, download.urlString);
    
    UIImage *imagen = download.image;
    if (imagen == nil) {
        NSLog(@"imagen = nil");
        imagen = [UIImage imageNamed:@"page.png"]; 
        download.delegate = self;
    } else {
        CGSize size = [imagen size];
        int x = (size.width/2 ) - 50;
        int y = (size.height/2 ) - 50;
        CGImageRef tmp = CGImageCreateWithImageInRect(imagen, CGRectMake(x, y, 100, 100));
        imagen = [UIImage imageWithCGImage:tmp];
    }
    UIView *view = [[[UIImageView alloc] initWithImage:imagen] autorelease];

    return view;
}

- (void)downloadDidFinishDownloading:(DeviantDownload *)download {
    
    NSUInteger index = [downloads indexOfObject:download]; 
    NSLog(@"Terminada descarga indice %i",index);
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
    [carousel reloadData];
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)car {
    int index = carousel.currentItemIndex;
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:index];
    nombreSerie.text = s.nombre;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 100;
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

@end
