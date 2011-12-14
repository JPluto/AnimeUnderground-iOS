//
//  DeviantDownload.m
//  AnimeUnderground
//
//  Created by Jeff Lamarche
//  Copyright 2011 AUDev. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "DeviantDownload.h"

@interface DeviantDownload()
@property (nonatomic, retain) NSMutableData *receivedData;
- (NSString *)md5Hash:(NSString *)clearText;
@end

@implementation DeviantDownload
//@synthesize urlString;
@synthesize image;
@synthesize delegate;
@synthesize receivedData;
#pragma mark -

- (void)setUrlString:(NSString *)anUrlString
{
    if (urlString != anUrlString) {
        [urlString release];
        [urlStringMD5 release];
        urlString = [anUrlString retain];
        urlStringMD5 = [[self md5Hash:anUrlString] retain];
    }
}

- (NSString *)urlString
{
    return [[urlString retain] autorelease]; 
}


- (UIImage *)image
{
    if (image == nil && !downloading)
    {
        if (urlString != nil && [urlString length] > 0)
        {            
            NSString *tmp = [[NSString alloc]initWithFormat:@"%@.png",urlStringMD5]; // [self md5Hash:urlString]
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
            
            NSString *cached = [[paths lastObject] stringByAppendingPathComponent:tmp];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cached]) {
                self.image = [[UIImage alloc] initWithContentsOfFile:cached];
                return self.image;
            }
            
            NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
            NSURLConnection *con = [[NSURLConnection alloc]
                                    initWithRequest:req
                                    delegate:self
                                    startImmediately:NO];
            [con scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
            [con start];
            
            
            
            if (con) 
            {
                NSMutableData *data = [[NSMutableData alloc] init];
                self.receivedData=data;
                [data release];
            } 
            else 
            {
                NSError *error = [NSError errorWithDomain:DeviantDownloadErrorDomain 
                                                     code:DeviantDownloadErrorNoConnection 
                                                 userInfo:nil];
                if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)])
                    [delegate download:self didFailWithError:error];
            }   
            [req release];
            
            downloading = YES;
        }
    }
    return image;
}
- (NSString *)filename
{
    return [urlString lastPathComponent];
}

- (NSString *)md5Hash:(NSString *)clearText
{
	const char *cStr = [clearText UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (void)dealloc 
{
    [urlString release];
    [image release];
    delegate = nil;
    [receivedData release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error 
{
    [connection release];
    if ([delegate respondsToSelector:@selector(download:didFailWithError:)])
        [delegate download:self didFailWithError:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    self.image = [UIImage imageWithData:receivedData];
    
    NSData *png = UIImagePNGRepresentation(image);
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.png",[self md5Hash:urlString]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    [png writeToFile:uniquePath atomically:YES];
    
    if ([delegate respondsToSelector:@selector(downloadDidFinishDownloading:)])
        [delegate downloadDidFinishDownloading:self];
    
    [connection release];
    self.receivedData = nil;
}
#pragma mark -
#pragma mark Comparison
- (NSComparisonResult)compare:(id)theOther
{
    DeviantDownload *other = (DeviantDownload *)theOther;
    return [self.filename compare:other.filename];
}
@end

