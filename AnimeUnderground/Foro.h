//
//  Foro.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 17/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Foro : NSObject {
    NSString *user;
    NSString *pass;
    NSHTTPCookie *authCookie;
}

@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *pass;

- (BOOL)doLogin;


@end
