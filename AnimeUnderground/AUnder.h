//
//  AUnder.h
//  AnimeUnderground
//
//  Created by Nacho L on 12/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Foro;
@class Serie;
@class Checkin;

@interface AUnder : NSObject {
    NSLock *lock;
    //Foro *foro;
    id updateHandler;
    
    NSArray *series;
    NSArray *entes;
    NSArray *noticias;
}

@property (nonatomic, retain) NSArray *series;
@property (nonatomic, retain) NSArray *entes;
@property (nonatomic, retain) NSArray *noticias;


+ (id)sharedInstance;
- (void)update;
- (void)updateWithAuth;
- (void)setUpdateHandler:(id)delegate;

- (Serie*)getSerieById:(int)codigo;

- (Foro *) foro;
- (Checkin *) checkin;
@end

// para callbacks

@interface NSObject(AUnderDelegates) 
- (void)onBeginUpdate:(AUnder*)aunder;
- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus;
- (void)onFinishUpdate:(AUnder*)aunder;
- (void)onUpdateError:(AUnder*)aunder;
@end


