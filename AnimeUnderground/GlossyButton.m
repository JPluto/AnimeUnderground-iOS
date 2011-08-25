//
//  GlossyButton.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "GlossyButton.h"


@implementation GlossyButton

@synthesize _color;
@synthesize gradientLayer;

//PRimera Saturacion de color ha de ser de menos de 0.30f la saturacion final ha de ser de +0.05 ese valor.
const float VALOR_DEGRADADO = 0.25f;
const float VALOR_SATURADO = 0.28f;
- (void)awakeFromNib;
{
    // Initialize the gradient layer
    gradientLayer = [[CAGradientLayer alloc] init];
    // Set its bounds to be the same of its parent
    [gradientLayer setBounds:[self bounds]];
    // Center the layer inside the parent layer
    [gradientLayer setPosition:
     CGPointMake([self bounds].size.width/2,
                 [self bounds].size.height/2)];
    
    // Insert the layer at position zero to make sure the 
    // text of the button is not obscured
    [[self layer] insertSublayer:gradientLayer atIndex:0];
    
    // Set the layer's corner radius
    [[self layer] setCornerRadius:12.0f];
    // Turn on masking
    [[self layer] setMasksToBounds:YES];
    // Display a border around the button 
    // with a 1.0 pixel width
    [[self layer] setBorderWidth:0.1f];


    
}
//TODO el valor de degradado y saturacion ha de variar segun la luminosidad del color.

- (void)drawRect:(CGRect)rect;
{
    if (_color)
    {
        // Set the colors for the gradient to the 
        // two colors specified for high and low
        UIColor *colorDegradado = [self degradaColor: _color];
        UIColor *colorDegradadoSaturado = [self saturaColor: _color];
        //Creo el juego de degradados que dan lugar a un boton glossy
        [gradientLayer setColors:
         [NSArray arrayWithObjects:
          (id)[colorDegradado CGColor],
          (id)[colorDegradadoSaturado CGColor],
          (id)[_color CGColor],
          (id)[_color CGColor],
          (id)[colorDegradadoSaturado CGColor],nil]];
        
        [gradientLayer setLocations:
         [NSArray arrayWithObjects:
          (id)[NSNumber numberWithFloat:0.0f],
          (id)[NSNumber numberWithFloat:0.44f],
          (id)[NSNumber numberWithFloat:0.45f],
          (id)[NSNumber numberWithFloat:0.5f],
          (id)[NSNumber numberWithFloat:1.0f],nil]];
        
        [gradientLayer setBorderColor:_color];
    }
    [super drawRect:rect];
}

- (void)setColor:(UIColor*)color;
{
    // Set the high color and repaint
    [self set_color:color];
    [[self layer] setNeedsDisplay];
}

- (void)dealloc {
    // Release our gradient layer
    [gradientLayer release];
    [super dealloc];
}

-(UIColor *) saturaColor: (UIColor *) color {
    CGFloat* colors = CGColorGetComponents(color.CGColor);
    float red = colors[0];
    float green = colors[1];
    float blue = colors[2];
    float alfa = colors[3];
    
    red = red + VALOR_SATURADO;
    green = green + VALOR_SATURADO;
    blue = blue + VALOR_SATURADO;

    if (red > 1.0f) {
        red = 1.0f;
    }
    if (green > 1.0f) {
        green = 1.0f;
    }
    if (blue > 1.0f) {
        blue = 1.0f;
    }
    UIColor *ret = [UIColor colorWithRed:red green:green blue:blue alpha:alfa];
    return ret;
}

-(UIColor *) degradaColor: (UIColor *) color {
    CGFloat* colors = CGColorGetComponents(color.CGColor);
    float red = colors[0];
    float green = colors[1];
    float blue = colors[2];
    float alfa = colors[3];
    
    red = red + VALOR_DEGRADADO;
    green = green + VALOR_DEGRADADO;
    blue = blue + VALOR_DEGRADADO;
    
    if (red > 1.0f) {
        red = 1.0f;
    }
    if (green > 1.0f) {
        green = 1.0f;
    }
    if (blue > 1.0f) {
        blue = 1.0f;
    }
    UIColor *ret = [UIColor colorWithRed:red green:green blue:blue alpha:alfa];
    return ret;
}
@end
