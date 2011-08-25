//
//  Foro.m
//  AnimeUnderground
//
//  Created by Nacho L on 17/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "Foro.h"


@implementation Foro
@synthesize user;
@synthesize pass;

	

- (BOOL) doLogin {
	if (authCookie!=NULL) [authCookie release];
	authCookie = NULL;
	
	for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
	{	
		if ([[cookie domain] isEqual:@"www.aunder.org"]) {
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
			NSLog(@"Brau");
		}
		
	}

	if (user==nil || pass==nil) {
		NSLog(@"doLogin ERROR: user o pass nulos");
		return NO;
	}
	
	if ([user isEqual:@""] || [pass isEqual:@""]) {
		NSLog(@"doLogin ERROR: user o pass vacios");
		return NO;
	}

	
	NSString *post =[NSString stringWithFormat:@"action=do_login&username=%@&password=%@",user, pass];
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSURL *url = [NSURL URLWithString:@"http://foro.aunder.org/member.php"];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
	[request setURL:url];	
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:30];
	[request setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];	
	
	NSHTTPURLResponse *response = NULL;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	NSString *responseDataString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"RESPONSE=%@",responseDataString);
	
	
	for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
	{	
		if (([[cookie domain] isEqual:@".aunder.org"]) && [[cookie name] isEqual:@"mybbuser"]) {
			NSLog(@"name: '%@'\n",   [cookie name]);
			NSLog(@"value: '%@'\n",  [cookie value]);
			NSLog(@"domain: '%@'\n", [cookie domain]);
			NSLog(@"path: '%@'\n",   [cookie path]);
			//[cookie retain];
			authCookie = cookie;
		}
		
	}
    
	if (authCookie == NULL) {
		NSLog(@"No se ha podido encontrar la cookie");
		return NO;
	}
	
	[authCookie retain];

	return YES;
}

- (NSString*) webPost: (NSString*) urlString:(NSString*) datosPost {
	
	NSData *postData = [datosPost dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	[request setURL:url];	
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:30];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];	
	
	NSHTTPURLResponse *response = NULL;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	NSString *responseDataString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"RESPONSE (POST)=%@",responseDataString);
	
	return [NSString stringWithString:responseDataString];
	
}

- (NSString*) webGet: (NSString*) urlString {
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    NSLog(@"GET %@",urlString);
    
	[request setURL:url];	
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:30];
	
	NSHTTPURLResponse *response = NULL;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	NSString *responseDataString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"RESPONSE (GET)=%@",responseDataString);
	
	return [NSString stringWithString:responseDataString];
}

@end
