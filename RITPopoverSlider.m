//
//  RITPopoverSlider.m
//  CustomerSlider
//
//  Created by Pronin Alexander on 10.09.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import "RITPopoverSlider.h"

@implementation RITPopoverSlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Add your method here.
        [self constructSlider];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customeTheAppearance];
        [self constructSlider];
    }
    return self;
}

-(void)customeTheAppearance{
    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_max.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    UIImage *thumbImage = [UIImage imageNamed:@"slidehandle.png"];
    [self setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}
#pragma mark - Helper methods
-(void)constructSlider {
    _popupView = [[RITPopoverView alloc] initWithFrame:CGRectMake(-5, -15, 40, 25)];
    //NSLog(@"%@",NSStringFromCGRect(self.thumbRect));
    _popupView.backgroundColor = [UIColor clearColor];
    //_popupView.alpha = 0.0;
    self.value = 0;
    [self addSubview:_popupView];
}

-(void)fadePopupViewInAndOut:(BOOL)aFadeIn {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (aFadeIn) {
        _popupView.alpha = 1.0;
    } else {
        _popupView.alpha = 0.0;
    }
    [UIView commitAnimations];
}

-(void)positionAndUpdatePopupView {
    //CGRect zeThumbRect = self.thumbRect;
    float x0 = self.thumbRect.origin.x-5;
    //CGRect zeThumbRect = CGRectMake(0, 0, 20, 10);
//    CGRect popupRect = CGRectOffset(zeThumbRect, 0, -floor(zeThumbRect.size.height*2));
    //_popupView.frame = CGRectInset(popupRect, -25, -20);
    _popupView.frame = CGRectMake(x0, -15, 40, 25);
    _popupView.value = self.value;
}

#pragma mark - Property accessors
-(CGRect)thumbRect {
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbR = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];
    return thumbR;
}

#pragma mark - UIControl touch event tracking
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade in and update the popup view
    CGPoint touchPoint = [touch locationInView:self];
    
    // Check if the knob is touched. If so, show the popup view
    if(CGRectContainsPoint(CGRectInset(self.thumbRect, -12.0, -12.0), touchPoint)) {
        [self positionAndUpdatePopupView];
        //[self fadePopupViewInAndOut:YES];
    }
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Update the popup view as slider knob is being moved
    [self positionAndUpdatePopupView];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade out the popup view
    //[self fadePopupViewInAndOut:NO];
    [super endTrackingWithTouch:touch withEvent:event];
}

@end
