//
//  GlossyButton.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuartzCore/QuartzCore.h"


@interface GlossyButton : UIButton {
    CAGradientLayer *gradientLayer;
    UIColor *_color;
}

@property (nonatomic,retain) CAGradientLayer *gradientLayer;
@property (nonatomic,retain) UIColor *_color;

- (void)setColor:(UIColor*)color;

@end
