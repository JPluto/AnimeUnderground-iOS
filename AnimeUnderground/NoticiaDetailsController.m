//
//  NoticiaDetailsController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 01/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "NoticiaDetailsController.h"
#import "iCarousel.h"
#import "DeviantDownload.h"
#import "Imagen.h"
#import "EnteDetailsController.h"

@implementation NoticiaDetailsController

@class AUnder,Noticia,ForoController;

@synthesize codigoNoticia;
@synthesize nombreNoticia;
@synthesize nombreAutor;
@synthesize fechaNoticia;
@synthesize textoNoticia;
@synthesize imagenesNoticia;
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
    [self.fechaNoticia release];
    [self.nombreNoticia release];
    [self.nombreAutor release];
    [self.fechaNoticia release];
    [self.textoNoticia release];
    [self.imagenesNoticia release];
    [self.scroll release];
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
    
    Noticia *noti = [[AUnder sharedInstance]getNoticiaByCodigo:codigoNoticia];
    self.title = [NSString stringWithFormat:@"Detalles de %@",[noti titulo]];
    self.fechaNoticia.text = [noti fecha];
    self.textoNoticia.text = [noti texto];
    self.textoNoticia.numberOfLines = 0;
    [self.textoNoticia sizeToFit];
    self.nombreNoticia.text = [noti titulo];
    self.nombreAutor.text = [[noti autor]nick];
    
    tid = [[NSString alloc]initWithString:[noti tid]];
    codigoEnte = [[noti autor]codigo];
    
    downloads = [[[NSMutableArray alloc]init]retain];
    totalImagenes = [[noti imagenes]count];
    for (Imagen *s in [noti imagenes]) {
        DeviantDownload *dd = [[DeviantDownload alloc]init];
        dd.urlString = [s getImageUrl];
        [downloads addObject: [dd retain]];
    }
    
    imagenesNoticia.type = iCarouselTypeCoverFlow;
    // habrá que añadir un loading al estilo de rootviewcontroller
    [imagenesNoticia reloadData];
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, (textoNoticia.frame.origin.y+textoNoticia.frame.size.height));
    
    
}
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imagenesNoticia = nil;
    self.fechaNoticia = nil;
    self.textoNoticia = nil;
    self.nombreNoticia = nil;
    self.nombreAutor = nil;
    self.scroll = nil;
    

}

-(IBAction)showEnteDetails {
    NSLog(@"Click en ente %d",codigoEnte);
    EnteDetailsController *edc = [[EnteDetailsController alloc]initWithEnteId:codigoEnte];
    [self.navigationController pushViewController:edc animated:YES];
}

-(IBAction)showForumThread {
    NSLog(@"Click en url %@",tid);
    ForoController *fc = [[ForoController alloc]init];
    [fc setUrlString:[NSString stringWithFormat:@"http://foro.aunder.org/showthread.php?tid=%@",tid]];
    [self.navigationController pushViewController:fc animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return totalImagenes;
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
        
    //UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
    
    return view;
}


- (void)downloadDidFinishDownloading:(DeviantDownload *)download {
    
    NSUInteger index = [downloads indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    [imagenesNoticia reloadData];
    download.delegate = nil;
}


- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 150;
}

- (CATransform3D)carousel:(iCarousel *)carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)car
{
    //wrap all carousels
    return NO;
}



@end
