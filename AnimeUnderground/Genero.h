//
//  Genero.h
//  AnimeUnderground
//
//  Created by Nacho L on 21/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serie.h"

@interface Genero : NSObject {
    NSString *nombre;
    NSMutableArray *series;
}

@property (nonatomic, retain) NSString *nombre;
@property (nonatomic, retain) NSMutableArray *series;

- (id)initWithNombre:(NSString*)aNombre;
+(void)addGeneros:(NSString *)generos:(Serie*)serie;
+(void)clearGeneros;
+(Genero*)getGenero:(NSString *)nombre;
+(NSArray*)getGeneros;

@end
