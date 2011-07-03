//
//  Serie.m
//  AnimeUnderground
//
//  Created by Nacho L on 14/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Serie.h"


@implementation Serie

@class Genero;

@synthesize codigo;
@synthesize nombre;
@synthesize sinopsis;
@synthesize estudio;
@synthesize capitulosTotales;
@synthesize capitulosActuales;
@synthesize imagen;
@synthesize imagenBoton;
@synthesize precuela;
@synthesize secuela;
@synthesize fuente;
@synthesize codecVideo;
@synthesize resolucion;
@synthesize codecAudio;
@synthesize contenedor;
@synthesize subtitulos;
@synthesize peso;
@synthesize recomendable;
@synthesize cancelada;
@synthesize terminada;
@synthesize staff;
@synthesize generos;

@class Genero;

-(NSString*) getGenerosString {
    NSLog(@"generos que veo yo: %d",[[Genero getGeneros]count]);
    NSString *res = [[NSString alloc]initWithString:@""];
    for (Genero *g in generos) {
        res = [res stringByAppendingFormat:@"%@,",[g nombre]];
    }
    if (res.length>0)
        res = [res substringToIndex:res.length-1];
    return res;
}

@end
