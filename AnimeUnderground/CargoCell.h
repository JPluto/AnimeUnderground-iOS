//
//  CargoCell.h
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerieDetailsController.h"

@interface CargoCell : UIView {
    
    UIScrollView *scrollView;
    SerieDetailsController *detailsController;
    
    UILabel *nombreLabel;
    UILabel *cargoLabel;
    UIImageView *avatarImage;
    UIView *backgroundView;
    int theIndex;
}

@property int theIndex;
@property (nonatomic, retain) SerieDetailsController *detailsController;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *nombreLabel;
@property (nonatomic, retain) UILabel *cargoLabel;
@property (nonatomic, retain) UIImageView *avatarImage;

@end
