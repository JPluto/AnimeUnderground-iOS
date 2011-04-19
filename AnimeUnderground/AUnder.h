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
    id updateHandler;
}

+ (id)sharedInstance;
- (BOOL)update;
- (void)setDelegate:(id)delegate;
- (void)doSomething;

@end

// para callbacks

@interface NSObject(AUnderDelegates) 
- (void)onBeginUpdate:(AUnder*)aunder;
- (void)onFinishUpdate:(AUnder*)aunder;
@end


