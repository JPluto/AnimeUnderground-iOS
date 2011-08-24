//
//  SeriesController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 08/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGridView.h"


@interface SeriesController : UIViewController <MMGridViewDataSource, MMGridViewDelegate> {
    NSMutableArray *downloads;
    int currentSelection;
}

@property (nonatomic, retain) IBOutlet MMGridView *gridView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel *nombreSerie;
-(IBAction)showSerieDetails;
-(void)setupGridPages;

@end