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
    
    NSArray *series;
}

+ (id)sharedInstance;
- (void)update;
- (void)setUpdateHandler:(id)delegate;

@end

// para callbacks

@interface NSObject(AUnderDelegates) 
- (void)onBeginUpdate:(AUnder*)aunder;
- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus;
- (void)onFinishUpdate:(AUnder*)aunder;
@end


