//
//  SeriesController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 08/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface SeriesController : UIViewController <iCarouselDataSource, iCarouselDelegate> {
    IBOutlet UIView *loadingView;
    IBOutlet UIActivityIndicatorView *loadingSpinner;
    NSMutableArray *downloads;
    int currentSelection;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) IBOutlet UILabel *nombreSerie;
-(IBAction)showSerieDetails;

@end