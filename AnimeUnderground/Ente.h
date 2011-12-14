//
//  Ente.h
//  AnimeUnderground
//
//  Created by Nacho L on 12/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Ente : NSObject {
    int codigo;
    NSString *nick;
    int uid;
    BOOL activo;
    NSString *avatar;
    NSString *titulo;
    NSString *ciudad;
    NSString *bio;
    NSString *sexo;
    int edad;
    NSMutableArray *cargos;
}

@property (nonatomic, assign) int codigo;
@property (nonatomic, retain) NSString *nick;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign, getter=isActivo) BOOL activo;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) NSString *ciudad;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *sexo;
@property (nonatomic, assign) int edad;
@property (nonatomic, retain) NSMutableArray *cargos;

- (id)initWithCodigo:(int)aCodigo nick:(NSString*)aNick;

@end
