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
    if (g!=NULL) 
        [[g series]addObject:serie];
    else {
        NSLog(@"Añadiendo género %@",nombre);
        g = [[Genero alloc]initWithNombre:nombre];
        [[g series] addObject:serie];
    }
    [[serie generos] addObject:g];
    [lock unlock];
}

+(void)addGeneros:(NSString *)generos:(Serie*)serie {
    [lock lock];
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:@"[.,!?:/;]+\\s*" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *matches = [regex matchesInString:generos options:0 range:NSMakeRange(0, [generos length])];
    
    for (NSTextCheckingResult *res in matches) {
        NSString *genero = [generos substringWithRange:[res range]];
        [self addGenero:genero :serie];
    }
    
    [lock unlock];
}

+(void)clearGeneros {
    if (generos == nil)
        generos = [[NSMutableArray alloc]init];
    else
        [generos removeAllObjects];
}

+(Genero*)getGenero:(NSString *)nombre {
    for (Genero *g in generos) 
        if ([[g nombre]isEqualToString:nombre])
            return g;
    
    return NULL;
}

+(NSArray*)getGeneros{
    return [NSArray arrayWithArray:generos];
}

@end
