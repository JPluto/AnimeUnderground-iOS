//
//  CheckinDetailsController.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 01/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Serie;

@interface CheckinDetailsController : UITableViewController {
    Serie *serie;
    NSMutableArray *capitulosCheck;
}

@end
