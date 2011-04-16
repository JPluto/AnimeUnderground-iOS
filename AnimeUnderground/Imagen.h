//
//  Imagen.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 16/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Imagen : NSObject {
    NSString *imagen;
}

@property (nonatomic,retain) NSString *imagen;

- (NSString*)getImageUrl;
- (NSString*)getThumbUrl;
- (NSString*)getMiniUrl;
@end
