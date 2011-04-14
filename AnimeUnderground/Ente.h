//
//  Ente.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 12/04/11.
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
    NSArray *cargos;
}

@end
