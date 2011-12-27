/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWWrapperUpdater.m                                                                           *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "SVWWrapperUpdater.h"

@implementation SVWWrapperUpdater

NSString * const kFileIgnore          = @"Ignore";
NSString * const kFileDelete          = @"Delete";
NSString * const kFileDirectory       = @"Dir";
NSString * const kFileListKey         = @"Files";

NSString * const kWrapperDescFilename = @"WrapperDesc";
NSString * const kWrapperDataFilename = @"WrapperData.zip";

- (id)init {
	self = [super init];
	if (self) {
		wrapperDesc = [[NSDictionary dictionaryWithContentsOfFile:
			       [[NSBundle mainBundle] pathForResource:kWrapperDescFilename ofType:@"plist"]] retain];
		if (wrapperDesc == nil) {
			wrapperDesc = [[NSDictionary alloc] init];
		}
	}
	return self;
}

- (void)dealloc {
	[wrapperDesc release];
	[super dealloc];
}

- (BOOL)checkForUpdates {
	NSDictionary *fileList = [wrapperDesc objectForKey:kFileListKey];
	if (fileList == nil || ![fileList isKindOfClass:[NSDictionary class]] || [fileList count] < 1)
		return NO;

	if ([[NSBundle mainBundle] pathForResource:kWrapperDataFilename ofType:nil] == nil)
		return NO;
	
	for (NSString *eachFilename in [fileList allKeys]) {
		id eachEntry = [fileList objectForKey:eachFilename];
		if (eachEntry == nil || ![eachEntry isKindOfClass:[NSString class]])
			continue;
		if ([self checkForUpdatesFile:eachFilename withInfo:(NSString *)eachEntry])
			return YES;
	}
	return NO;
}

- (BOOL)checkForUpdatesFile:(NSString *)filename withInfo:(NSString *)fileinfo {
#pragma unused (filename)
	if ([fileinfo isEqualToString:kFileIgnore])
		return NO;
	if ([fileinfo isEqualToString:kFileDelete]) {
		// TODO: Check if file exists and return YES
		return NO;
	}
	if ([fileinfo isEqualToString:kFileDirectory]) {
		// TODO: Check if dir is missing and return YES
		return NO;
	}
	// TODO: check if file is missing and return YES
	
	// TODO: check if file digest doesn't match and return YES
	return NO;
}

- (BOOL)update {
	NSDictionary *fileList = [wrapperDesc objectForKey:kFileListKey];
	for (NSString *eachFilename in [fileList allKeys]) {
		id eachEntry = [fileList objectForKey:eachFilename];
		if (eachEntry == nil || ![eachEntry isKindOfClass:[NSString class]])
			continue;
		if (![self updateFile:eachFilename withInfo:(NSString *)eachEntry])
			return NO;
	}
	return YES;
}

- (BOOL)updateFile:(NSString *)filename withInfo:(NSString *)fileinfo {
#pragma unused (filename)
	if (![self checkForUpdatesFile:filename withInfo:fileinfo])
		return YES;

	if ([fileinfo isEqualToString:kFileDelete]) {
		// TODO: Check if file exists and delete it, return success state
		return YES;
	}
	if ([fileinfo isEqualToString:kFileDirectory]) {
		// TODO: Check if dir is missing and create it, return success state
		return YES;
	}
	// TODO: extract file and overwrite, return success state
	return YES;
}

@end
