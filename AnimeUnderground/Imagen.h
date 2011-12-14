//
//  Imagen.h
//  AnimeUnderground
//
//  Created by Nacho L on 16/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Imagen : NSObject {
    NSString *imagen;
}

@property (nonatomic,retain) NSString *imagen;


- (id)initWithImagen:(NSString*)anImagen;
- (NSString*)getImageUrl;
- (NSString*)getThumbUrl;
- (NSString*)getMiniUrl;
@end
