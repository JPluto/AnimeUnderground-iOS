//
//  CheckinCell.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 01/09/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckinCell : UITableViewCell {
    UILabel *numero;
    UIImageView *check;
    
}

@property (nonatomic,retain) IBOutlet UILabel *numero;
@property (nonatomic,retain) IBOutlet UIImageView *check;

@end
