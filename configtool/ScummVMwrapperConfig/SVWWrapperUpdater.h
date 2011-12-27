/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWWrapperUpdater.h                                                                           *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Foundation/Foundation.h>

@class ZipFile;

@interface SVWWrapperUpdater : NSObject {
	NSDictionary *wrapperDesc;
	ZipFile *updateArchive;
}

- (BOOL)checkForUpdates;
- (BOOL)checkForUpdatesFile:(NSString *)filename withInfo:(NSString *)fileinfo;
- (BOOL)updateFile:(NSString *)filename withInfo:(NSString *)fileinfo;
- (NSString *)sanitizeFilename:(NSString *)filename;
- (NSString *)destinationFilename:(NSString *)filename;

@end
