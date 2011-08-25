//
//  SeriesController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 08/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGridView.h"
#import "SliderPageControl.h"

@interface SeriesController : UIViewController <MMGridViewDataSource, MMGridViewDelegate> {
    NSMutableArray *downloads;
    SliderPageControl *sliderPageControl;
    int randomSerieIndex;
	BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet MMGridView *gridView;
@property (nonatomic, retain) IBOutlet UILabel *nombreSerie;
@property (nonatomic, retain) IBOutlet UIImageView *imagenSerie;
@property (nonatomic, retain) IBOutlet UILabel *datosSerie;
@property (nonatomic, retain) SliderPageControl *sliderPageControl;

-(IBAction)showRandomSerieDetails;
-(void)setupGridPages;

@end