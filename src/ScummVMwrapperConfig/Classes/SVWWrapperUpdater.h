/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWWrapperUpdater.h                                                                           *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Foundation/Foundation.h>

@class ZipFile;

@interface SVWWrapperUpdater : NSObject {
    NSDictionary *wrapperDesc;
    ZipFile *updateArchive;
}

- (BOOL)checkForUpdates;
- (BOOL)checkForUpdatesFile:(NSString *)filename withInfo:(NSDictionary *)fileinfo;
- (BOOL)updateFile:(NSString *)filename withInfo:(NSDictionary *)fileinfo;
- (BOOL)update;
- (NSString *)sanitizeFilename:(NSString *)filename;
- (NSString *)destinationFilename:(NSString *)filename;
- (BOOL)createBlankAtPath:(NSString *)destination;

@end
