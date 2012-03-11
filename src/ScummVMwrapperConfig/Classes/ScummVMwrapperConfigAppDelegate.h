/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             ScummVMwrapperConfigAppDelegate.h                                                             *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>

#pragma mark Interface
@interface ScummVMwrapperConfigAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

#pragma mark Properties
@property (assign) IBOutlet NSWindow *window;

@end
