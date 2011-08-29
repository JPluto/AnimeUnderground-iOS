//
//  EnteCell.h
//  AnimeUnderground
//
//  Created by Nacho L. on 29/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnteCell : UITableViewCell {
    IBOutlet UIImageView *imagenAvatar;
    IBOutlet UILabel *nickEnte;
    IBOutlet UIActivityIndicatorView *loading;

}

@property (nonatomic, retain) IBOutlet UIImageView *imagenAvatar;
@property (nonatomic, retain) IBOutlet UILabel *nickEnte;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loading;
@end
