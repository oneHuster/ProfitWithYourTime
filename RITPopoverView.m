//
//  RITPopoverView.m
//  CustomerSlider
//
//  Created by Pronin Alexander on 10.09.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import "RITPopoverView.h"

@implementation RITPopoverView {
    UILabel *textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:13.0f];
        
        UIImageView *popoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideTitle.png"]];
        popoverView.frame = self.bounds;
        self.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:popoverView];
        
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = self.font;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.text = self.text;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.frame = CGRectMake(0, -2.0f, popoverView.frame.size.width, popoverView.frame.size.height);
        [self addSubview:textLabel];
        
    }
    return self;
}

-(void)setValue:(float)aValue {
    
    if (aValue<0.2) {
        aValue = 0;
    }else if (aValue<0.4 && aValue>=0.2){
        aValue = 20;
    }else if (aValue<0.6&&aValue>=0.4){
        aValue = 40;
    }else if (aValue<0.8&&aValue>=0.6){
        aValue = 60;
    }else
        aValue = 80;
    _value = aValue;
    self.text = [NSString stringWithFormat:@"%0.f元", _value];
    textLabel.text = self.text;
    [self setNeedsDisplay];
}

@end
