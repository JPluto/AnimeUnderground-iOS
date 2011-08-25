//
//  AUnder.h
//  AnimeUnderground
//
//  Created by Nacho L on 12/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Foro;

@interface AUnder : NSObject {
    NSLock *lock;
    Foro *foro;
    id updateHandler;
    
    NSArray *series;
    NSArray *entes;
    NSArray *noticias;
}

@property (nonatomic, retain) NSArray *series;
@property (nonatomic, retain) Foro *foro;
@property (nonatomic, retain) NSArray *entes;
@property (nonatomic, retain) NSArray *noticias;


+ (id)sharedInstance;
- (void)update;
- (void)setUpdateHandler:(id)delegate;

@end

// para callbacks

@interface NSObject(AUnderDelegates) 
- (void)onBeginUpdate:(AUnder*)aunder;
- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus;
- (void)onFinishUpdate:(AUnder*)aunder;
- (void)onUpdateError:(AUnder*)aunder;
@end


