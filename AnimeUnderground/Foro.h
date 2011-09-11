//
//  Foro.h
//  AnimeUnderground
//
//  Created by Nacho L on 17/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Foro : NSObject {
    NSString *user;
    NSString *pass;
    NSString *uid;
    NSHTTPCookie *authCookie;
}

@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *pass;
@property (nonatomic, retain) NSString *uid;

- (BOOL)doLogin;
- (BOOL)isLogged;
- (NSString*) webGet: (NSString*) urlString;
- (NSString*) webPost: (NSString*) urlString:(NSString*) datosPost ;
@end
