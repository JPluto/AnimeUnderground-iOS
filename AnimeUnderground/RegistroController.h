//
//  RegistroController.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistroController : UIViewController {
    UIButton *registrarseB;
}

@property (nonatomic,retain) IBOutlet UIButton *registrarseB;


-(IBAction) preRegistrarse;
-(IBAction) registrarse;
@end
