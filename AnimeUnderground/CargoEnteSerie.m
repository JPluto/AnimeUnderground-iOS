//
//  CargoEnteSerie.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 14/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "CargoEnteSerie.h"


@implementation CargoEnteSerie
@synthesize ente;
@synthesize serie;
@synthesize cargo;
@synthesize capitulos;

//=========================================================== 
// - (id)initWith:
//
//=========================================================== 
- (id)initWithEnte:(Ente*)anEnte serie:(Serie*)aSerie cargo:(NSString*)aCargo capitulos:(int)aCapitulos 
{
    self = [super init];
    if (self) {
        ente = [anEnte retain];
        serie = [aSerie retain];
        cargo = [aCargo retain];
        capitulos = aCapitulos;
    }
    return self;
}

- (void)dealloc {
    [ente release], ente=nil;
    [serie release], serie=nil;
    [cargo release], cargo = nil;
    [super dealloc];
}

@end
