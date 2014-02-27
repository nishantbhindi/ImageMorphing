//
//  ViewController.m
//  ImageMorphing
//
//  Created by WebInfoways on 27/04/13.
//  Copyright (c) 2013 WebInfoways. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "UIPopover-iPhone.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scale;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setGesture];
    
    //[self doImageProcess];
}
#pragma mark - Gesture
-(void)setGesture{
    UIGestureRecognizer *ges = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [viewData addGestureRecognizer:ges];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleSelfWith:)] autorelease];
    [pinchRecognizer setDelegate:self];
    //[viewHairStyle addGestureRecognizer:pinchRecognizer];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
}
-(void)scaleSelfWith:(UIPinchGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer numberOfTouches] >1) {
        
        //getting width and height between gestureCenter and one of my finger
        //float x = [gestureRecognizer locationInView:self].x - [gestureRecognizer locationOfTouch:1 inView:self].x;
        float x = [gestureRecognizer locationInView:viewHairStyle].x - [gestureRecognizer locationOfTouch:1 inView:viewHairStyle].x;
        if (x<0) {
            x *= -1;
        }
        //float y = [gestureRecognizer locationInView:self].y - [gestureRecognizer locationOfTouch:1 inView:self].y;
        float y = [gestureRecognizer locationInView:viewHairStyle].y - [gestureRecognizer locationOfTouch:1 inView:viewHairStyle].y;
        if (y<0) {
            y *= -1;
        }
        
        //set Border
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            xDis = viewHairStyle.bounds.size.width - x*2;
            yDis = viewHairStyle.bounds.size.height - y*2;
        }
        
        //double size cause x and y is just the way from the middle to my finger
        float width = x*2+xDis;
        if (width < 1) {
            width = 1;
        }
        float height = y*2+yDis;
        if (height < 1) {
            height = 1;
        }
        viewHairStyle.bounds = CGRectMake(viewHairStyle.bounds.origin.x , viewHairStyle.bounds.origin.y , width, height);
        [gestureRecognizer setScale:1];
        //[[viewHairStyle layer] setBorderWidth:2.f];
    }
}
-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = viewHairStyle.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [viewHairStyle setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //[self showOverlayWithFrame:viewHairStyle.frame];
}
-(void)move:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:viewHairStyle];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [imgHairStyle center].x;
        _firstY = [imgHairStyle center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [imgHairStyle setCenter:translatedPoint];
    //[self showOverlayWithFrame:viewHairStyle.frame];
}
#pragma mark UIGestureRegognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

#pragma mark - Image Process
-(void)doImageProcess
{
    /*UIImage *inputImage = [UIImage imageNamed:@"Celebrity.png"];
    GPUImageBulgeDistortionFilter *stillImageFilter = [[GPUImageBulgeDistortionFilter alloc] init];
    UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:inputImage];*/
    
    //CIFilter *objFilter = [[CIFilter alloc] init];
    //CIBumpDistortionLinear
    
    // 1
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Celebrity" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    
    // 2
    CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    
    /*
    //Part-1
    // 3
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                   keysAndValues: kCIInputImageKey, beginImage,
                         @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
     
    // 4
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
    imgDestination.image = newImage;
    
    //Part-1 End
    */
    
    /*
    //Part-2
    
    //Putting in Context//
    // 1
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.2, nil];
    CIImage *outputImage = [filter outputImage];
    
    // 2
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    // 3
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    imgDestination.image = newImage;
    
    // 4
    CGImageRelease(cgimg);
    
    //Part-2 End
    */
    
    
    /*
    //Part-3
    
    //Putting in Context//
    // 1
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //CIVector *vector = [CIVector vectorWithString:@"[50 50]"];
    CIVector *vector = [CIVector vectorWithX:75 Y:150];
    
    //CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortionLinear"
                                  keysAndValues: kCIInputImageKey, beginImage,
                                    @"inputRadius", @400.0,
                                    @"inputAngle", @10.0,
                                    @"inputScale", @0.5, nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortionLinear"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputCenter", vector,
                        @"inputRadius", @400.0,
                        @"inputAngle", @20.0,
                        @"inputScale", @0.5, nil];
    
    CIImage *outputImage = [filter outputImage];
    
    // 2
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    // 3
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    imgDestination.image = newImage;
    
    // 4
    CGImageRelease(cgimg);
    
    //Part-3 End
    */
    
    
    //Part-4
    
    // Make the input image recipe
    CIImage *inputImage = [CIImage imageWithCGImage:imgSource.image.CGImage];
    
    // Make tone filter filter
    // See mentioned link for visual reference
    CIFilter *toneCurveFilter = [CIFilter filterWithName:@"CIBumpDistortionLinear"];
    [toneCurveFilter setDefaults];
    [toneCurveFilter setValue:inputImage forKey:kCIInputImageKey];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.0  Y:0.0] forKey:@"inputCenter"];
    [toneCurveFilter setValue:@400 forKey:@"inputRadius"];    //@200
    [toneCurveFilter setValue:@10.0 forKey:@"inputAngle"];    //@10.0
    [toneCurveFilter setValue:@0.5 forKey:@"inputScale"];   //0.5
    
    self.scale = @0.5;
    
    /*[toneCurveFilter setValue:[CIVector vectorWithX:0.27 Y:0.26] forKey:@"inputPoint1"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.5  Y:0.80] forKey:@"inputPoint2"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.7  Y:1.0] forKey:@"inputPoint3"];
    [toneCurveFilter setValue:[CIVector vectorWithX:1.0  Y:1.0] forKey:@"inputPoint4"]; // default
    */
    
    // Get the output image recipe
    CIImage *outputImage = [toneCurveFilter outputImage];
    
    // Create the context and instruct CoreImage to draw the output image recipe into a CGImage
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    imgDestination.image = newImage;
    
    //Part-4 End
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    startPoint = [touch locationInView:imgDestination];
    
    if ([touch view] == imgDestination){
        
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    */
    
    /*
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:imgDestination];
    NSLog(@"%f  %f",currentPoint.x,currentPoint.y);
    
    if (startPoint.x < currentPoint.x) {
        // Right swipe
        startPoint = currentPoint;
        
        int value = [self.scale intValue];
        self.scale = [NSNumber numberWithInt:value - 1];
    } else {
        // Left swipe
        startPoint = currentPoint;
        
        int value = [self.scale intValue];
        self.scale = [NSNumber numberWithInt:value + 1];
    }
    
    CIImage *inputImage = [CIImage imageWithCGImage:imgDestination.image.CGImage];
    
    // Make tone filter filter
    // See mentioned link for visual reference
    CIFilter *toneCurveFilter = [CIFilter filterWithName:@"CIBumpDistortionLinear"];
    [toneCurveFilter setDefaults];
    [toneCurveFilter setValue:inputImage forKey:kCIInputImageKey];
    //[toneCurveFilter setValue:[CIVector vectorWithX:currentPoint.x  Y:currentPoint.y] forKey:@"inputCenter"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.0  Y:0.0] forKey:@"inputCenter"];
    //[toneCurveFilter setValue:@400.0 forKey:@"inputRadius"];
    [toneCurveFilter setValue:@1.0 forKey:@"inputAngle"];       //@10.0
    [toneCurveFilter setValue:@0.5 forKey:@"inputScale"];       //@0.5
    //[toneCurveFilter setValue:self.scale forKey:@"inputScale"];       //@0.5
    
    // Get the output image recipe
    CIImage *outputImage = [toneCurveFilter outputImage];
    
    // Create the context and instruct CoreImage to draw the output image recipe into a CGImage
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    imgDestination.image = newImage;
    */
    
    
    /*
    if ([touch view] == imgDestination){
        CGPoint currentPoint = [touch locationInView:imgDestination];
        NSLog(@"%f  %f",currentPoint.x,currentPoint.y);
        
        CIImage *inputImage = [CIImage imageWithCGImage:imgDestination.image.CGImage];
        
        // Make tone filter filter
        // See mentioned link for visual reference
        CIFilter *toneCurveFilter = [CIFilter filterWithName:@"CIBumpDistortionLinear"];
        [toneCurveFilter setDefaults];
        [toneCurveFilter setValue:inputImage forKey:kCIInputImageKey];
        [toneCurveFilter setValue:[CIVector vectorWithX:currentPoint.x  Y:currentPoint.y] forKey:@"inputCenter"];
        //[toneCurveFilter setValue:@200.0 forKey:@"inputRadius"];
        [toneCurveFilter setValue:@10.0 forKey:@"inputAngle"];
        [toneCurveFilter setValue:@0.5 forKey:@"inputScale"];
        
        // Get the output image recipe
        CIImage *outputImage = [toneCurveFilter outputImage];
        
        // Create the context and instruct CoreImage to draw the output image recipe into a CGImage
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        
        UIImage *newImage = [UIImage imageWithCGImage:cgimg];
        imgDestination.image = newImage;
    }*/
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)displayPopover:(id)sender
{
    //ViewController2 *objViewController2 = [[ViewController2 alloc] init];
    ViewController2 *objViewController2 = [[ViewController2 alloc] initWithNibName:@"ViewController2" bundle:nil];
    UIPopoverController *objPopover = [[UIPopoverController alloc] initWithContentViewController:objViewController2];
    objPopover.delegate = self;
    //[objViewController2 release];
    
    currPopover = objPopover;
    //[objPopover release];
    
    //[currPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
  
    [objPopover presentPopoverFromRect:CGRectMake(10.0, 10.0, 300.0, 528.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    /*
    ViewController2 * popupController = [[ViewController2 alloc] initWithNibName:@"ViewController2" bundle:nil];
    //[popupController setDelegate:self];
    UIPopoverController *aPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:popupController];
    //[popupController release];
    
    //[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [aPopover presentPopoverFromRect:CGRectMake(10.0, 10.0, 300.0, 528.0)  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     */
}

@end
