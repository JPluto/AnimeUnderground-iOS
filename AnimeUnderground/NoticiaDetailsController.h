//
//  NoticiaDetailsController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 01/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface NoticiaDetailsController : UIViewController {
    int codigoNoticia;
    NSMutableArray *downloads;
    int totalImagenes;
}

@property int codigoNoticia;

@property (nonatomic,retain) IBOutlet UILabel *nombreNoticia;
@property (nonatomic,retain) IBOutlet UILabel *nombreAutor;
@property (nonatomic,retain) IBOutlet UILabel *fechaNoticia;
@property (nonatomic,retain) IBOutlet UILabel *textoNoticia;
@property (nonatomic,retain) IBOutlet iCarousel *imagenesNoticia;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

@end