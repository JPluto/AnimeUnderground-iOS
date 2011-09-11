//
//  Checkin.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 04/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Foro;
@class Serie;
//private Cookie cookie;
//private Foro foro;
//private HashMap<Serie,List<Integer>> checkins;
//private CheckInHandler cHandler = null;

@interface Checkin : NSObject {
    NSHTTPCookie *cookie;
    //Foro *foro; si el foro lo puedo obtener a partir de AUnder.foro para que tener una copia ?
    NSMutableDictionary *checkins;
}


- (BOOL) isInitialized;
-(NSMutableArray*) getSerieInfo: (Serie *)serie;
-(void) add: (Serie*) serie elCapitulo:(NSNumber*) capitulo;
-(void) add:(Serie*) serie losCapitulos:(NSMutableArray*) capitulos;
-(void) addAll:(Serie*) serie;
-(void) del:(Serie*)serie elCapitulo:(NSNumber *) capitulo;
-(void) delAll:(Serie*)serie;

@end
