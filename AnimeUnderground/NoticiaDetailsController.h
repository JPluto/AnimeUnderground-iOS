//
//  NoticiaDetailsController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 01/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DeviantDownload.h"

@interface NoticiaDetailsController : UIViewController<DeviantDownloadDelegate> {
    int codigoNoticia;
    NSMutableArray *downloads;
    int totalImagenes;
    NSString *tid;
    int codigoEnte;
}

@property (nonatomic, assign) int codigoNoticia;

@property (nonatomic,retain) IBOutlet UILabel *nombreNoticia;
@property (nonatomic,retain) IBOutlet UILabel *nombreAutor;
@property (nonatomic,retain) IBOutlet UILabel *fechaNoticia;
@property (nonatomic,retain) IBOutlet UILabel *textoNoticia;
@property (nonatomic,retain) IBOutlet iCarousel *imagenesNoticia;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

-(IBAction)showEnteDetails;
-(IBAction)showForumThread;

@end
