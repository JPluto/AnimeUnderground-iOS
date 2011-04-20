//
//  RootViewController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 06/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
    IBOutlet UIView *loadingView;
    IBOutlet UILabel *loadingText;
    IBOutlet UIActivityIndicatorView *loadingSpinner;
}

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UILabel *loadingText;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end
