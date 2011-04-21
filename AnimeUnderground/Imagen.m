//
//  Imagen.m
//  AnimeUnderground
//
//  Created by Nacho L on 16/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Imagen.h"


@implementation Imagen
@synthesize imagen;

//=========================================================== 
// - (id)initWith:
//
//=========================================================== 
- (id)initWithImagen:(NSString*)anImagen  
{
    self = [super init];
    if (self) {
        imagen = [anImagen retain];
    }
    return self;
}



- (NSString*)getImageUrl {
    return imagen;
}
- (NSString*)getThumbUrl {
    return [NSString stringWithFormat:@"%@.thumb.jpg"];
}
- (NSString*)getMiniUrl {
    return [NSString stringWithFormat:@"%@.mini.jpg"];
}
@end
