/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWWrapperUpdater.h                                                                           *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Foundation/Foundation.h>

@interface SVWWrapperUpdater : NSObject {
	NSDictionary *wrapperDesc;
}

- (BOOL)checkForUpdates;
- (BOOL)checkForUpdatesFile:(NSString *)filename withInfo:(NSString *)fileinfo;
- (BOOL)updateFile:(NSString *)filename withInfo:(NSString *)fileinfo;

@end
