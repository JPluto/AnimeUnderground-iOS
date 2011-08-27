//
//  EnteDetailsController.h
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ente.h"

@interface EnteDetailsController : UIViewController {
    Ente *ente;
    IBOutlet UILabel *enteNick;
}

@property (nonatomic, retain) IBOutlet UILabel *enteNick;

- (id)initWithEnteId:(int)enteId;

@end
