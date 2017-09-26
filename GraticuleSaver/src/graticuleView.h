//
//  screensaver001View.h
//  screensaver001
//
//  Copyright © 2017 Kay Stenschke. All rights reserved.

#import <ScreenSaver/ScreenSaver.h>

@interface graticuleView: ScreenSaverView {
    // keep track of whether or not drawRect: should erase the background
    BOOL mDrawBackground;
}
@end