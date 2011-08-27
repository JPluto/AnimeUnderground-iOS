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
        self.backgroundView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview: self.backgroundView];
        
        self.avatarImage = [[[UIImageView alloc]initWithFrame:CGRectNull]autorelease];
        
        
        self.nombreLabel = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
        self.nombreLabel.textAlignment = UITextAlignmentCenter;
        self.nombreLabel.backgroundColor = [UIColor clearColor];
        self.nombreLabel.textColor = [UIColor blackColor];
        self.nombreLabel.font = [UIFont systemFontOfSize:12];
                
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
    
    self.nombreLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.nombreLabel.frame = CGRectInset(CGRectMake(0,0,backgroundView.bounds.size.width,backgroundView.bounds.size.height),inset,inset);
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
