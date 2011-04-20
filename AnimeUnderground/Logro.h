//
//  Logro.h
//  AnimeUnderground
//
//  Created by Nacho L on 16/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Imagen;

@interface Logro : NSObject {
    int codigo;
    NSString *nombre;
    Imagen *imagen;
    NSString *descripcion;
    NSString *explicacion;
}
@property (nonatomic, assign) int codigo;
@property (nonatomic, retain) NSString *nombre;
@property (nonatomic, retain) Imagen *imagen;
@property (nonatomic, retain) NSString *descripcion;
@property (nonatomic, retain) NSString *explicacion;
@end
