//
//  Serie.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 14/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Serie : NSObject {
    int codigo;
    NSString *nombre;
    NSString *sinopsis;
    NSString *estudio;
    int capitulosTotales;
    int capitulosActuales;
    NSString *imagen;
    NSString *imagenBoton;
    Serie *precuela;
    Serie *secuela;
    NSString *fuente;
    NSString *codecVideo;
    NSString *resolucion;
    NSString *codecAudio;
    NSString *contenedor;
    NSString *subtitulos;
    int peso;
    BOOL recomendable;
    BOOL cancelada;
    BOOL terminada;
    
    NSArray *generos;
    NSArray *staff;
}

@end
