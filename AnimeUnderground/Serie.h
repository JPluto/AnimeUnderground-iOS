//
//  Serie.h
//  AnimeUnderground
//
//  Created by Nacho L on 14/04/11.
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
    
    NSMutableArray *generos;
    NSMutableArray *staff;
}

@property (nonatomic, assign) int codigo;
@property (nonatomic, retain) NSString *nombre;
@property (nonatomic, retain) NSString *sinopsis;
@property (nonatomic, retain) NSString *estudio;
@property (nonatomic, assign) int capitulosTotales;
@property (nonatomic, assign) int capitulosActuales;
@property (nonatomic, retain) NSString *imagen;
@property (nonatomic, retain) NSString *imagenBoton;
@property (nonatomic, retain) Serie *precuela;
@property (nonatomic, retain) Serie *secuela;
@property (nonatomic, retain) NSString *fuente;
@property (nonatomic, retain) NSString *codecVideo;
@property (nonatomic, retain) NSString *resolucion;
@property (nonatomic, retain) NSString *codecAudio;
@property (nonatomic, retain) NSString *contenedor;
@property (nonatomic, retain) NSString *subtitulos;
@property (nonatomic, assign) int peso;
@property (nonatomic, assign, getter=isRecomendable) BOOL recomendable;
@property (nonatomic, assign, getter=isCancelada) BOOL cancelada;
@property (nonatomic, assign, getter=isTerminada) BOOL terminada;
@property (nonatomic, retain) NSMutableArray *staff;
@property (nonatomic, retain) NSMutableArray *generos;

@end
