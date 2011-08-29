//
//  EnteDetailsController.h
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ente.h"
#import "MMGridView.h"

@interface EnteDetailsController : UIViewController <MMGridViewDataSource, MMGridViewDelegate> {
    Ente *ente;
    IBOutlet UILabel *estado;
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *subnick;
    IBOutlet UILabel *datosExtra;
    NSMutableArray *imagenes;
    NSMutableArray *forLazyLoading;
    NSMutableArray *forLazySpinners;
}

@property (nonatomic, retain) IBOutlet MMGridView *gridView;
@property (nonatomic, retain) IBOutlet UILabel *estado;
@property (nonatomic, retain) IBOutlet UIImageView *avatar;
@property (nonatomic, retain) IBOutlet UILabel *subnick;
@property (nonatomic, retain) IBOutlet UILabel *datosExtra;

- (id)initWithEnteId:(int)enteId;

@end
