//
//  Noticia.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Ente, Serie;

@interface Noticia : NSObject {
    int codigo;
    NSString *titulo;
    Ente *autor;
    NSString *fecha;
    NSString *texto;
    NSString *enlace;
    Serie *serie;
    NSString *tid;
    NSArray *descargas;
    NSArray *imagenes;
}

@property (nonatomic, assign) int codigo;
@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) Ente *autor;
@property (nonatomic, retain) NSString *fecha;
@property (nonatomic, retain) NSString *texto;
@property (nonatomic, retain) NSString *enlace;
@property (nonatomic, retain) Serie *serie;
@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSArray *descargas;
@property (nonatomic, retain) NSArray *imagenes;


@end
