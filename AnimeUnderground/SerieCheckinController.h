//
//  NoticiaCheckinController.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 15/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Serie.h"

@interface SerieCheckinController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIImageView *image;
    UITableView *listaCheckins;
    Serie *_serie;
    NSMutableArray *capitulosCheck;
}

@property (nonatomic,retain) IBOutlet UIImageView *image;
@property (nonatomic,retain) IBOutlet UITableView *listaCheckins;

-(void) setSerie:(Serie*) serie;
-(IBAction) doCheckin:(id) sender;


@end
