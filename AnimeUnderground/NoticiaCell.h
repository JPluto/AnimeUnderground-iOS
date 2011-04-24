//
//  NoticiaCell.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 24/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoticiaCell : UITableViewCell {
    IBOutlet UIImageView *imagen;
    IBOutlet UILabel *titulo;
    IBOutlet UILabel *autor;
    IBOutlet UILabel *fecha;
    IBOutlet UIActivityIndicatorView *loading;
}

@property (nonatomic, retain) IBOutlet UIImageView *imagen;
@property (nonatomic, retain) IBOutlet UILabel *titulo;
@property (nonatomic, retain) IBOutlet UILabel *autor;
@property (nonatomic, retain) IBOutlet UILabel *fecha;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *loading;
@end
