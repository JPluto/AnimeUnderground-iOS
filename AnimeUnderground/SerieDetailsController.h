//
//  SerieDetailsController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 05/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Serie.h"

@interface SerieDetailsController : UIViewController {
    int codigoSerie;
    Serie *serie;
    IBOutlet UILabel *numeroCapitulos;
    IBOutlet UILabel *nombreEstudio;
    IBOutlet UILabel *generos;
    IBOutlet UILabel *sinopsis;
    IBOutlet UIImageView *imagen;
    IBOutlet UIScrollView *scroll;
}
@property (nonatomic, assign) int codigoSerie;
@property (nonatomic, retain) IBOutlet UILabel *numeroCapitulos;
@property (nonatomic, retain) IBOutlet UILabel *nombreEstudio;
@property (nonatomic, retain) IBOutlet UILabel *generos;
@property (nonatomic, retain) IBOutlet UILabel *sinopsis;
@property (nonatomic, retain) IBOutlet UIImageView *imagen;
@property (nonatomic, retain) IBOutlet UIScrollView *scroll;
@end
