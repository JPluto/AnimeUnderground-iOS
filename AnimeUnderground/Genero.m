//
//  Genero.m
//  AnimeUnderground
//
//  Created by Nacho L on 21/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Genero.h"


@implementation Genero
@synthesize nombre;
@synthesize series;

static NSMutableArray *generos;
static NSLock *lock;

- (id)initWithNombre:(NSString*)aNombre
{
    self = [super init];
    if (self) {
        nombre = [aNombre retain];
    }
    return self;
}

+(void)addGenero:(NSString*)nombre:(Serie*)serie {
    [lock lock];
    Genero *g = [self getGenero:nombre];
    if (g==nil) {
        NSLog(@"Añadiendo género %@",nombre);
        g = [[Genero alloc]initWithNombre:nombre];
        [generos addObject:g];
    }
    [[g series] addObject:serie];
    [[serie generos] addObject:g];
    [lock unlock];
}

+(void)addGeneros:(NSString *)generos:(Serie*)serie {
    [lock lock];
    
    NSString *separadores = @".,-/";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:separadores];
    NSArray *matches = [generos componentsSeparatedByCharactersInSet:set];
    
    for (NSString *genero in matches) {
        if (![genero isEqualToString:@""])
            [self addGenero:genero:serie];
    }
    
    [lock unlock];
}

+(void)clearGeneros {
    if (generos == nil)
        generos = [[[NSMutableArray alloc]init]retain];
    else
        [generos removeAllObjects];
}

+(Genero*)getGenero:(NSString *)nombre {
    for (Genero *g in generos) {
        if ([[g nombre] isEqualToString:nombre]) {
            return g;
        }
    }
    return nil;
}

+(NSArray*)getGeneros{
    return [NSArray arrayWithArray:generos];
}

@end
