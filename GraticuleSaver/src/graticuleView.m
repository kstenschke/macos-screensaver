#import "graticuleView.h"

@implementation graticuleView

NSSize screenSize;

int scene   = 1;
int frame = 0;

bool fadeInNew  = false;
bool fadeOutOld = false;

float fadeNewMultiplier  = 1.0;
float fadeOldMultiplier = 1.0;

double dotSizeSubtract = 0.0;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1 / 35.0];
    }
    return self;
}

- (void)startAnimation{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

/**
 * @return currentContext
 */
- (CGContextRef)getCurrentContext {
    return [NSGraphicsContext.currentContext graphicsPort];
}

/**
 * @param fadeInNew
 * @param fadeOutOld
 */
- (void)handleFade:(bool)fadeInNew fadeOutOld:(bool)fadeOutOld {
    if (!fadeInNew) {
        fadeNewMultiplier = 1.0;
    } else if (fadeNewMultiplier < 1.0){
        fadeNewMultiplier += 0.1;
    }

    if (!fadeOutOld) {
        fadeOldMultiplier = 1.0;
    } else if (fadeOldMultiplier > 0.0) {
        fadeOldMultiplier -= 0.1;
    }
}

- (void)draw_blackBars:(NSRect)rectBlue timerOffset:(double)timerOffset fade:(float)fade {
    BOOL odd = true;
    NSBezierPath *path;
    NSColor *colorGrey = [NSColor colorWithCalibratedRed: 0 green:0 blue:0 alpha:.8 * fade];

    for (int y = 0; y < screenSize.height; y+= screenSize.height / 20.0 ) {
        rectBlue.origin.x = 0;
        double r = y + ((y * 10) * sin( (y * timerOffset) / screenSize.height)) / 100.0;
        rectBlue.origin.y = screenSize.height / 40 + r;
        path = [NSBezierPath bezierPathWithRect:rectBlue];
        
        if (odd) {
            odd = false;
        } else {
            odd = true;
            [colorGrey set];
            [path fill];
        }
    }
}

- (double)rolloPanels:(NSRect *)rect fade:(float)fade{
    NSBezierPath *path;
    NSColor *color;
    double colorValue = 145.0 / 255.0;

    rect->size = NSMakeSize( screenSize.width, screenSize.height / 20.0 );

    double timerOffset = CACurrentMediaTime() / 1.0;
    
    for (int y = 0; y < screenSize.height; y+= screenSize.height / 40.0 ) {
        rect->origin.x = 0;
        rect->origin.y = screenSize.height / 20 + y + ((y * 10) * sin( (y * timerOffset) / screenSize.height)) / 220.0;
        path = [NSBezierPath bezierPathWithRect:*rect];

        color = [NSColor colorWithCalibratedRed:colorValue * 100.0
                                              green:colorValue * 100.0
                                               blue:colorValue * 100.0
                                              alpha:.3 * fade];
        [color set];
        [path fill];
    }
    return timerOffset;
}

- (void)karos:(NSRect)rectBlue  fade:(float)fade{
    double timerOffset = [self rolloPanels:&rectBlue fade:fade];

    NSRect rect = rectBlue;
    BOOL isOdd = true;

    NSBezierPath *path;
    NSColor *color;

    double colorValue = 223.0 / 255.0;

    rect.size  = NSMakeSize( screenSize.width / 20.0, screenSize.height );

    for (int x = 0; x < screenSize.width; x+= screenSize.width / 40.0 ) {
        rect.origin.x = -100 + screenSize.width / 20 + x + ((x * 10) * sin( (x * timerOffset) / screenSize.width)) / 220.0;
        path = [NSBezierPath bezierPathWithRect:rect];
        
        if (isOdd) {
            color = [NSColor colorWithCalibratedRed:colorValue * 10.0
                                              green:colorValue * 10.0
                                               blue:colorValue * 10.0
                                              alpha:.2 * fade];
            isOdd = false;
        } else {
            color = [NSColor colorWithCalibratedRed: 0.0 green:0.0 blue:0.0 alpha:.8 * fade];
            isOdd = true;
        }
        [color set];
        [path fill];
    }
    
    [self draw_blackBars:rectBlue timerOffset:timerOffset fade:fade];
}

- (void)polkaDots:(NSRect)rectBlue fade:(float)fade{
    double timerOffset = CACurrentMediaTime() * 5.0;
    
    CGContextRef context = self.getCurrentContext;
    
    CGContextSetRGBStrokeColor (context, 1.0, 1.0, 1.0, 1.0 * fade);
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, .8);
    CGContextSetLineWidth (context, 2.0);

    for (int y = -200; y < screenSize.height + 300; y+= screenSize.height / 10 ) {
        for (int x = -100; x < screenSize.width; x+= screenSize.height / 10 ) {
            int sinBase = x;
            double r = ((sinBase) * sin( (x * timerOffset) / screenSize.width)) / 200.0;
            double s = ((sinBase) * cos( (y * timerOffset) / screenSize.width)) / 200.0;
            
            CGRect innerRect = CGRectMake(x, y, 30 + r, 30 + s);
            CGContextFillEllipseInRect (context, innerRect);
        }
    }
}

- (void)fourWins:(NSRect)rectBlue fade:(float)fade{
    double timerOffset = CACurrentMediaTime() * 5.0;
    
    CGContextRef context = self.getCurrentContext;
    
    CGContextSetRGBStrokeColor (context, 1.0, 1.0, 1.0, 1.0 * fade);
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, .1 * fade);
    CGContextSetLineWidth (context, 2.0);

    for (int y = -200; y < screenSize.height + 300; y+= screenSize.height / 10 ) {
        for (int x = -100; x < screenSize.width; x+= screenSize.height / 10 ) {
            int sinBase = x;
            double r = ((sinBase) * sin( (x * timerOffset) / screenSize.width)) / 200.0;
            double s = ((sinBase) * cos( (y * timerOffset) / screenSize.width)) / 200.0;
            
            CGRect innerRect = CGRectMake(x, y, 20 * r, 20 * s);
            CGContextFillEllipseInRect (context, innerRect);
        }
    }
}

- (void)verticalDrape:(NSRect)rectBlue fade:(float)fade{
    double timerOffset = CACurrentMediaTime();
    
    CGContextRef context = self.getCurrentContext;
    
    CGContextSetRGBStrokeColor (context, 1.0, 1.0, 1.0, 1.0 * fade);
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, .4 * fade);
    CGContextSetLineWidth (context, 2.0);

    for (int y = -200; y < screenSize.height + 300; y+= screenSize.height / 10 ) {
        for (int x = -100; x < screenSize.width; x+= screenSize.height / 10 ) {
            int sinBase = x + y;
            double r = (sinBase * sin( (x * timerOffset) / screenSize.width)) / 20.0;
            double s = (sinBase * cos( (y * timerOffset) / screenSize.width)) / 20.0;
            
            CGContextFillEllipseInRect (context, CGRectMake(x, screenSize.height/2, r * x / 200, 30 + s * y * 500));
            CGContextFillEllipseInRect (context, CGRectMake(y, screenSize.height/2, y * s / 200, 30 * s * x * 400));
        }
    }
}

- (void)verticalDrapesWandering:(NSRect)rectBlue fade:(float)fade{
    double timerOffset = CACurrentMediaTime();
    
    CGContextRef context = self.getCurrentContext;
    
    CGContextSetRGBStrokeColor (context, 1.0, 1.0, 1.0, 1.0 * fade);
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, .4 * fade);
    CGContextSetLineWidth (context, 2.0);

    for (int y = -200; y < screenSize.height + 300; y+= screenSize.height / 10 ) {
        for (int x = -100; x < screenSize.width; x+= screenSize.height / 10 ) {
            int sinBase = x + y;
            double r = (sinBase * sin( (x * timerOffset) / screenSize.width)) / 20.0;
            double s = (sinBase * cos( (y * timerOffset) / screenSize.width)) / 20.0;

            CGContextFillEllipseInRect(context, CGRectMake(
                    x,
                    screenSize.height / 2 + sin(timerOffset) * screenSize.height / 2,
                    r * x / 200,
                    30 + s * y * 500));

            CGContextFillEllipseInRect(context, CGRectMake(
                    y,
                    screenSize.height / 2 + sin(timerOffset) * screenSize.height / 2,
                    y * s / 200,
                    30 * s * x * 400));
        }
    }
}

/**
 * Main routine: evoke drawing current animation scene
 *
 * @param rectBlue
 */
- (void)drawRect:(NSRect)rectBlue {
    if (mDrawBackground) {
        // Draw background after view is installed in a window for the first time
        [[NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0] set];
        [NSBezierPath fillRect: [self bounds]];
        mDrawBackground = NO;
    }
    screenSize = [self bounds].size;

    int framesInScene = 100;
    frame++;

    [self handleFade:fadeInNew fadeOutOld:fadeOutOld];

//    scene = 0;
    switch (scene) {
        case 1:
            fadeInNew  = false;
            fadeOutOld = false;
            fadeNewMultiplier = 0.0;
            fadeOldMultiplier = 1.0;
            framesInScene = 1;
            break;
        case 2:
            [self karos:rectBlue fade:fadeOldMultiplier];
            [self polkaDots:rectBlue fade:fadeNewMultiplier];
            [self fourWins:rectBlue fade:1.0];
            framesInScene = 50 + arc4random_uniform(50);
            break;
        case 3:
            // Matrix of dots swirling around like torch light spots
            dotSizeSubtract = 0.0;
            [self fourWins:rectBlue fade:1.0];
            framesInScene = 50 + arc4random_uniform(50);
            break;
        case 4:
            // Vertical stripes w/ split horizontally across, moving horizontal
            [self verticalDrape:rectBlue fade:1.0];
            framesInScene = 50 + arc4random_uniform(50);
            break;
        case 5:
            // Combo of 4 + 3 + polka dots
            [self verticalDrape:rectBlue fade:1.0];
            [self fourWins:rectBlue fade:1.0];
            [self polkaDots:rectBlue fade:1.0];
            framesInScene = 50 + arc4random_uniform(50);
            break;
        case 6:
            [self verticalDrapesWandering:rectBlue fade:1.0];
            framesInScene = 50 + arc4random_uniform(50);
            break;
    }

    if (frame > framesInScene) {
        frame = 1;

        scene++;
        if (scene == 7) {
            scene = 1;
        }
    }

    mDrawBackground = YES;
}

- (BOOL)isOpaque {
    // This keeps Cocoa from unnecessarily redrawing our superview
    return YES;
}

- (void)viewDidMoveToWindow {
    // This NSView method is called when our screen saver view is added to its window
    // we'll use this signal to tell drawRect: to erase the background
    mDrawBackground = YES;
}

- (void)animateOneFrame
{
    //   request that our view be redrawn (causes Cocoa to call drawRect:)
    [self setNeedsDisplay: YES];
    
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
