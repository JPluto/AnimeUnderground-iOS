//
//  AUnder.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Foro;

@interface AUnder : NSObject {
    NSLock *lock;
    Foro *foro;
}

+ (id)sharedInstance;
- (BOOL)update;
@end
