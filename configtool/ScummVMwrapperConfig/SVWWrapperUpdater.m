/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWWrapperUpdater.m                                                                           *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "SVWWrapperUpdater.h"
#import "ZipFile.h"
#import "CocoaCryptoHashing.h"

@implementation SVWWrapperUpdater

NSString * const kFileIgnore          = @"Ignore";
NSString * const kFileDelete          = @"Delete";
NSString * const kFileDirectory       = @"Dir";
NSString * const kFileListKey         = @"Files";

NSString * const kWrapperDescFilename = @"WrapperDesc";
NSString * const kWrapperDataFilename = @"WrapperData.zip";

NSUInteger const kMaxFileLength       = 1000*1000*50; // 50MB

- (id)init {
	self = [super init];
	if (self) {
		wrapperDesc = [[NSDictionary dictionaryWithContentsOfFile:
			       [[NSBundle mainBundle] pathForResource:kWrapperDescFilename ofType:@"plist"]] retain];
		if (wrapperDesc == nil) {
			wrapperDesc = [[NSDictionary alloc] init];
		}
		updateArchive = [[ZipFile alloc] initWithFileAtPath:
				 [[NSBundle mainBundle] pathForResource:kWrapperDataFilename ofType:nil]];
		if (![updateArchive open]) {
			[updateArchive release];
			updateArchive = nil;
		}
	}
	return self;
}

- (void)dealloc {
	[wrapperDesc release];
	if (updateArchive != nil) {
		[updateArchive close];
		[updateArchive release];
	}
	[super dealloc];
}

- (BOOL)checkForUpdates {
	NSDictionary *fileList = [wrapperDesc objectForKey:kFileListKey];
	if (fileList == nil || ![fileList isKindOfClass:[NSDictionary class]] || [fileList count] < 1)
		return NO;

	if (updateArchive == nil)
		return NO;
	
	for (NSString *eachFilename in [fileList allKeys]) {
		id eachEntry = [fileList objectForKey:eachFilename];
		if (eachEntry == nil || ![eachEntry isKindOfClass:[NSString class]])
			continue;
		if ([self checkForUpdatesFile:[self sanitizeFilename:eachFilename] withInfo:(NSString *)eachEntry])
			return YES;
	}
	return NO;
}

- (BOOL)checkForUpdatesFile:(NSString *)filename withInfo:(NSString *)fileinfo {
#pragma unused (filename)
	if ([fileinfo isEqualToString:kFileIgnore])
		return NO;
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL exists = [fm fileExistsAtPath:[self destinationFilename:filename] isDirectory:&isDir];
	if ([fileinfo isEqualToString:kFileDelete]) {
		return exists;
	}
	if ([fileinfo isEqualToString:kFileDirectory]) {
		return !(exists && isDir);
	}
	if (!exists || isDir) {
		return YES;
	}
	NSString *digest = [[NSFileHandle fileHandleForReadingAtPath:[self destinationFilename:filename]] md5HexHash];
	if (digest == nil)
		return YES;
	return ![[digest uppercaseString] isEqualToString:[fileinfo uppercaseString]];
}

- (BOOL)update {
	NSDictionary *fileList = [wrapperDesc objectForKey:kFileListKey];
	for (NSString *eachFilename in [fileList allKeys]) {
		id eachEntry = [fileList objectForKey:eachFilename];
		if (eachEntry == nil || ![eachEntry isKindOfClass:[NSString class]])
			continue;
		if (![self updateFile:[self sanitizeFilename:eachFilename] withInfo:(NSString *)eachEntry])
			return NO;
	}
	return YES;
}

- (BOOL)updateFile:(NSString *)filename withInfo:(NSString *)fileinfo {
#pragma unused (filename)
	if (![self checkForUpdatesFile:filename withInfo:fileinfo])
		return YES;

	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fileinfo isEqualToString:kFileDelete]) {
		return [fm removeItemAtPath:[self destinationFilename:filename] error:NULL];
	}
	// If file exists, it's either the wrong type or its digest doesn't match.  Let's delete it first.
	if ([fm fileExistsAtPath:[self destinationFilename:filename]]
	    && ![fm removeItemAtPath:[self destinationFilename:filename] error:NULL])
		return NO;
	if ([fileinfo isEqualToString:kFileDirectory]) {
		return [fm createDirectoryAtPath:[self destinationFilename:filename] withIntermediateDirectories:YES
				      attributes:nil error:NULL];
	}
	NSData *fileData = [updateArchive readWithFileName:filename maxLength:kMaxFileLength];
	return [fileData writeToFile:[self destinationFilename:filename] atomically:YES];
}

- (NSString *)sanitizeFilename:(NSString *)filename {
	return [filename stringByReplacingOccurrencesOfString:@"../" withString:@""];
}

- (NSString *)destinationFilename:(NSString *)filename {
	return [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
		stringByAppendingPathComponent:[self sanitizeFilename:filename]];
}

@end
