//
//  Descarga.h
//  AnimeUnderground
//
//  Created by Nacho L on 16/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Noticia;

@interface Descarga : NSObject {
    NSString *version;
    NSString *enlace;
    NSString *tipo;
    Noticia *noticia;
}

+(NSArray*)descargas;

@end
