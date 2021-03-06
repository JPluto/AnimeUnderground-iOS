//
//  Ente.m
//  AnimeUnderground
//
//  Created by Nacho L on 12/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Ente.h"


@implementation Ente
@synthesize codigo;
@synthesize nick;
@synthesize uid;
@synthesize activo;
@synthesize avatar;
@synthesize titulo;
@synthesize ciudad;
@synthesize bio;
@synthesize sexo;
@synthesize edad;
@synthesize cargos;


- (id)initWithCodigo:(int)aCodigo nick:(NSString*)aNick 
{
    self = [super init];
    if (self) {
        codigo = aCodigo;
        nick = [aNick retain];
        cargos = [[NSMutableArray alloc]init];
    }
    return self;
}


@end
