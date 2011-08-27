//
//  CargoCell.h
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CargoCell : UIView {
    UIScrollView *scrollView;
    
    UILabel *nombreLabel;
    UILabel *cargoLabel;
    UIImageView *avatarImage;
    UIView *backgroundView;
}

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *nombreLabel;
@property (nonatomic, retain) UILabel *cargoLabel;
@property (nonatomic, retain) UIImageView *avatarImage;

@end
