//
//  CargoEnteSerie.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 14/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Ente, Serie;

@interface CargoEnteSerie : NSObject {
    Ente *ente;
    Serie *serie;
    NSString *cargo;
    int capitulos;
}

@end
