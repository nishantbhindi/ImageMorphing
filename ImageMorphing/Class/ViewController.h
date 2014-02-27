//
//  ViewController.h
//  ImageMorphing
//
//  Created by WebInfoways on 27/04/13.
//  Copyright (c) 2013 WebInfoways. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPopoverControllerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *imgSource;
    IBOutlet UIImageView *imgDestination;
    
    CGPoint startPoint;
    NSNumber *scale;
    
    UIPopoverController *currPopover;
    
    ////
    IBOutlet UIView *viewData;
    
    IBOutlet UIView *viewHairStyle;
    IBOutlet UIImageView *imgHairStyle;
    CGFloat xDis;
    CGFloat yDis;
    
    CGFloat _lastScale;
	CGFloat _lastRotation;
    CGFloat _firstX;
	CGFloat _firstY;
}

@property (nonatomic,retain)NSNumber *scale;

-(void)setGesture;

-(void)doImageProcess;

- (IBAction)displayPopover:(id)sender;

@end
