/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             ScummVMwrapperConfigAppDelegate.h                                                             *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************
 * $Id::                                                                     $: SVN Info                           *
 * $Date::                                                                   $: Last modification                  *
 * $Author::                                                                 $: Last modification author           *
 * $Revision::                                                               $: SVN Revision                       *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>

@interface ScummVMwrapperConfigAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
