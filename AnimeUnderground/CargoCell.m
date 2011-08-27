//
//  CargoCell.m
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CargoCell.h"

@implementation CargoCell

@synthesize scrollView;
@synthesize nombreLabel;
@synthesize avatarImage;
@synthesize backgroundView;
@synthesize cargoLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundView = [[[UIView alloc]initWithFrame:CGRectNull] autorelease];
        
        [self addSubview: self.backgroundView];
        
        self.avatarImage = [[[UIImageView alloc]initWithFrame:CGRectNull]autorelease];
        
        [self.backgroundView addSubview:self.avatarImage];

        self.cargoLabel = [[[UILabel alloc]initWithFrame:CGRectNull] autorelease];
        self.cargoLabel.textAlignment = UITextAlignmentCenter;
        self.cargoLabel.backgroundColor = [UIColor clearColor];
        self.cargoLabel.textColor = [UIColor blackColor];
        self.cargoLabel.font = [UIFont systemFontOfSize:10];
        self.cargoLabel.numberOfLines = 2;
        
        [self.backgroundView addSubview:self.cargoLabel];
        
        self.nombreLabel = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
        self.nombreLabel.textAlignment = UITextAlignmentCenter;
        self.nombreLabel.backgroundColor = [UIColor clearColor];
        self.nombreLabel.textColor = [UIColor blackColor];
        self.nombreLabel.font = [UIFont systemFontOfSize:15];
                
        [self.backgroundView addSubview:self.nombreLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //int labelHeight = 30;
    int inset = 5;
    
    self.backgroundView.frame = CGRectInset(self.bounds, inset, inset);
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.avatarImage.frame = CGRectMake(5, 5, 50, 50);
    
    self.nombreLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.nombreLabel.frame = CGRectInset(CGRectMake(0,0,backgroundView.bounds.size.width,backgroundView.bounds.size.height/2),inset,inset);
    
    self.cargoLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.cargoLabel.frame = CGRectMake(0,20,backgroundView.bounds.size.width,40);
}


#pragma - Touch event handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:scrollView];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    SEL singleTapSelector = @selector(cellWasSelected:);
    SEL doubleTapSelector = @selector(cellWasDoubleTapped:);
    
    if (scrollView) {
        UITouch *touch = [touches anyObject];
        
        switch ([touch tapCount]) 
        {
            case 1:
                [scrollView performSelector:singleTapSelector withObject:self afterDelay:.3];
                break;
                
            case 2:
                [scrollView performSelector:doubleTapSelector withObject:self];
                break;
                
            default:
                break;
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
