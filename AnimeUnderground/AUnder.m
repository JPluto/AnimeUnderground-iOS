//
//  AUnder.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AUnder.h"


@implementation AUnder
@class TBXML;

static AUnder* sharedInstance = nil;

+(AUnder*)sharedInstance {
    if (sharedInstance == nil) 
        sharedInstance = [[super allocWithZone:NULL]init];
    
    return sharedInstance;
}


- (BOOL)update {
    
    [lock lock];
    
    // series, entes, noticias
    TBXML *tb = [[TBXML alloc] initWithXMLString:@""];
    
    [lock unlock];
    
    return NO;
}


// functiones necesarias para singleton

+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (void)release {
	
}
- (id)autorelease {
    return self;
}

@end
