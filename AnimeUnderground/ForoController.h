//
//  ForoController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 30/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForoController : UIViewController <UIWebViewDelegate>{
    UIWebView *webView;
    NSString *urlString;
    IBOutlet UIActivityIndicatorView *loadSpinner;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadSpinner;

@end
