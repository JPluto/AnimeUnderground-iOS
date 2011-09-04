//
//  Checkin.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 04/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Foro;

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
@end
