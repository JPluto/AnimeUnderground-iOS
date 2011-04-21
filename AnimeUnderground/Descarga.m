//
//  Descarga.m
//  AnimeUnderground
//
//  Created by Nacho L on 16/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Descarga.h"


@implementation Descarga
@synthesize noticia, version;

static NSMutableArray *descargas;


+(NSArray*)descargas {
    return [NSArray arrayWithArray:descargas];
}

//=========================================================== 
// - (id)initWith:
//
//=========================================================== 
- (id)initWithEnlace:(NSString*)anEnlace tipo:(NSString*)aTipo 
{
    self = [super init];
    if (self) {
        enlace = [anEnlace retain];
        tipo = [aTipo retain];
    }
    return self;
}


@end
