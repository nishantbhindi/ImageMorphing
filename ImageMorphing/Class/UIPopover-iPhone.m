//
//  UIPopover-iPhone.m
//  ImageMorphing
//
//  Created by WebInfoways on 27/04/13.
//  Copyright (c) 2013 WebInfoways. All rights reserved.
//

#import "UIPopover-iPhone.h"

@implementation UIPopoverController (overrides)

+ (BOOL)_popoversDisabled
{
    return NO;
}

@end
