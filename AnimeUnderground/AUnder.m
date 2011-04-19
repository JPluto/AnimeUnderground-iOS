//
//  AUnder.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AUnder.h"

#define URL_SERIES "http://www.aunder.org/xml/seriesxml.php"

@implementation AUnder
@class TBXML;

static AUnder* sharedInstance = nil;
static Foro* theForo = nil;

+(AUnder*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

- (Foro*)foro {
    if (!foro) 
        foro = [[Foro alloc]init];
    
    return foro;
}

- (void)setUpdateHandler:(id)aDelegate {
    updateHandler = aDelegate; /// Not retained
}

- (BOOL)update {
    
    [lock lock];
    [updateHandler onBeginUpdate:self];
    // series, entes, noticias

    TBXML *tb = [[TBXML alloc] initWithXMLString:[[self foro] webGet:@"http://www.aunder.org/xml/seriesxml.php"]];
    
        
    [tb release];
    
    [lock unlock];
    [updateHandler onFinishUpdate:self];
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
