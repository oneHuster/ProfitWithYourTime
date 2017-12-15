//
//  RITPopoverSlider.h
//  CustomerSlider
//
//  Created by Pronin Alexander on 10.09.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITPopoverView.h"

@interface RITPopoverSlider : UISlider

@property (strong, nonatomic) RITPopoverView *popupView;
@property (nonatomic, readonly) CGRect thumbRect;

@end
