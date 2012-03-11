/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWWrapperUpdater.m                                                                           *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "SVWWrapperUpdater.h"
#import "ZipFile.h"
#import "CocoaCryptoHashing.h"

@implementation SVWWrapperUpdater

NSString * const kFileIgnore          = @"Ignore";
NSString * const kFileDelete          = @"Delete";
NSString * const kFileDirectory       = @"Dir";
NSString * const kFileFile            = @"File";
NSString * const kFileSelf            = @"Self";
NSString * const kFileListKey         = @"Files";

NSString * const kFileInfoType        = @"Type";
NSString * const kFileInfoSum         = @"Checksum";
NSString * const kFileInfoMod         = @"Permissions";

NSString * const kWrapperDescFilename = @"WrapperDesc";
NSString * const kWrapperInfoFilename = @"WrapperInfo";
NSString * const kWrapperDataFilename = @"WrapperData.zip";
NSString * const kWrapperContentsDir  = @"Contents";

NSUInteger const kMaxFileLength       = 1000*1000*50; // 50MB

- (id)init {
	self = [super init];
	if (self) {
		wrapperDesc = [[NSDictionary dictionaryWithContentsOfFile:
			       [[NSBundle mainBundle] pathForResource:kWrapperDescFilename ofType:@"plist"]] retain];
		if (wrapperDesc == nil)
			wrapperDesc = [[NSDictionary alloc] init];
		updateArchive = nil;
		NSString *wrapperDataFilePath = [[NSBundle mainBundle] pathForResource:kWrapperDataFilename ofType:nil];
		if (wrapperDataFilePath != nil) {
			updateArchive = [[ZipFile alloc] initWithFileAtPath:wrapperDataFilePath];
			if (![updateArchive open]) {
				[updateArchive release];
				updateArchive = nil;
			}
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
		if (eachEntry == nil || ![eachEntry isKindOfClass:[NSDictionary class]])
			continue;
		if ([self checkForUpdatesFile:[self sanitizeFilename:eachFilename] withInfo:(NSDictionary *)eachEntry])
			return YES;
	}
	return NO;
}

- (BOOL)checkForUpdatesFile:(NSString *)filename withInfo:(NSDictionary *)fileinfo {
#pragma unused (filename)
	NSString *fileType = [fileinfo objectForKey:kFileInfoType];
	NSString *fileSum = [fileinfo objectForKey:kFileInfoSum];
	NSNumber *fileMod = [fileinfo objectForKey:kFileInfoMod];
	if (fileType == nil || fileSum == nil || fileMod == nil)
		return NO;

	if ([fileType isEqualToString:kFileIgnore] || [fileType isEqualToString:kFileSelf])
		return NO;

	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL exists = [fm fileExistsAtPath:[self destinationFilename:filename] isDirectory:&isDir];

	if ([fileType isEqualToString:kFileDelete])
		return exists;

	if ([fileType isEqualToString:kFileDirectory])
		return !(exists && isDir);

	if (!exists || isDir)
		return YES;

	NSDictionary *fileAttribs = [fm attributesOfItemAtPath:[self destinationFilename:filename] error:NULL];
	NSNumber *currentFileMod = [fileAttribs objectForKey:NSFilePosixPermissions];
	if (currentFileMod == nil || [currentFileMod unsignedLongValue] != [fileMod unsignedLongValue])
		return YES;

	NSString *digest = [[NSFileHandle fileHandleForReadingAtPath:[self destinationFilename:filename]] md5HexHash];
	if (digest == nil)
		return YES;

	return ![[digest lowercaseString] isEqualToString:[fileSum lowercaseString]];
}

- (BOOL)update {
	NSDictionary *fileList = [wrapperDesc objectForKey:kFileListKey];
	for (NSString *eachFilename in [fileList allKeys]) {
        NSLog(@"Updating %@", eachFilename);
		id eachEntry = [fileList objectForKey:eachFilename];
		if (eachEntry == nil || ![eachEntry isKindOfClass:[NSDictionary class]])
			continue;
		if (![self updateFile:[self sanitizeFilename:eachFilename] withInfo:(NSDictionary *)eachEntry])
			return NO;
        NSLog(@"Updated it");
	}
    // Ensure Info.plist consistency
    // TODO: Maybe this is part of SVWSettings.
    NSArray *keys = [NSArray arrayWithObjects:
                     @"LSApplicationCategoryType",
                     @"LSMinimumSystemVersion",
                     @"NSHumanReadableCopyright",
                     @"NSMainNibFile",
                     @"LSUIElement",
                     nil];
    NSDictionary *newInfoDict = [NSDictionary dictionaryWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:kWrapperInfoFilename ofType:@"plist"]];
    NSMutableDictionary *oldInfoDict = [NSMutableDictionary dictionaryWithContentsOfFile:
                                        [self destinationFilename:@"Contents/Info.plist"]];
    NSLog(@"New dict is: %@", newInfoDict);
    for (NSString *eachKey in keys) {
        id eachObject = [newInfoDict objectForKey:eachKey];
        if (eachObject != nil) {
            NSLog(@"Setting value %@ for key %@", eachObject, eachKey);
            [oldInfoDict setObject:eachObject forKey:eachKey];
        }
    }
    [oldInfoDict writeToFile:[self destinationFilename:@"Contents/Info.plist"] atomically:YES];
	return YES;
}

- (BOOL)updateFile:(NSString *)filename withInfo:(NSDictionary *)fileinfo {
#pragma unused (filename)
    NSLog(@"Updating file %@", filename);
	if (![self checkForUpdatesFile:filename withInfo:fileinfo]) {
        NSLog(@"Was up to date");
		return YES;
    }

	NSString *fileType = [fileinfo objectForKey:kFileInfoType];
	NSNumber *fileMod = [fileinfo objectForKey:kFileInfoMod];
	NSDictionary *fileAttribs = [NSDictionary dictionaryWithObject:fileMod forKey:NSFilePosixPermissions];
	NSFileManager *fm = [NSFileManager defaultManager];

	if ([fileType isEqualToString:kFileDelete]) {
        NSLog(@"Deleting it");
		return [fm removeItemAtPath:[self destinationFilename:filename] error:NULL];
    }

	// If file exists, it's either the wrong type or its digest doesn't match.  Let's delete it first.
	if ([fm fileExistsAtPath:[self destinationFilename:filename]]
	    && ![fm removeItemAtPath:[self destinationFilename:filename] error:NULL]) {
        NSLog(@"Unable to remove file");
		return NO;
    }

	if ([fileType isEqualToString:kFileDirectory]) {
        NSLog(@"Creating dir");
		return [fm createDirectoryAtPath:[self destinationFilename:filename] withIntermediateDirectories:YES
				      attributes:fileAttribs error:NULL];
    }

	if (![fm fileExistsAtPath:[self destinationFilename:[filename stringByDeletingLastPathComponent]]] &&
	    ![fm createDirectoryAtPath:[self destinationFilename:[filename stringByDeletingLastPathComponent]]
	   withIntermediateDirectories:YES attributes:nil error:NULL]) {
            NSLog(@"Unable to create parent directory");
		return NO;
	}

	NSData *fileData = [updateArchive readWithFileName:filename maxLength:kMaxFileLength];

    NSLog(@"Regular update");
	return [fm createFileAtPath:[self destinationFilename:filename] contents:fileData attributes:fileAttribs];
}

- (NSString *)sanitizeFilename:(NSString *)filename {
	return [filename stringByReplacingOccurrencesOfString:@"../" withString:@""];
}

- (NSString *)destinationFilename:(NSString *)filename {
	return [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
		stringByAppendingPathComponent:[self sanitizeFilename:filename]];
}

- (BOOL)createBlankAtPath:(NSString *)destination {
	NSFileManager *fm = [NSFileManager defaultManager];

	if ([fm fileExistsAtPath:destination] && ![fm removeItemAtPath:destination error:nil])
		return NO;

	if (![fm createDirectoryAtPath:[destination stringByAppendingPathComponent:kWrapperContentsDir]
	   withIntermediateDirectories:YES attributes:nil error:nil])
		return NO;

	if (![fm copyItemAtPath:[[NSBundle mainBundle] bundlePath]
			 toPath:[destination
				 stringByAppendingPathComponent:[[[NSBundle mainBundle] bundlePath] lastPathComponent]]
			  error:nil])
		return NO;

	// FIXME: This shouldn't be needed anymore.  Remove?
//	NSDictionary *infoDict = [NSDictionary
//				  dictionaryWithContentsOfFile:[[NSBundle mainBundle]
//								pathForResource:kWrapperInfoFilename ofType:@"plist"]];
//	[infoDict writeToFile:[[destination
//				stringByAppendingPathComponent:kWrapperContentsDir]
//			       stringByAppendingPathComponent:@"Info.plist"] atomically:YES];

	// TODO: make it auto-extract the update archive
	NSDictionary *fileList = [wrapperDesc objectForKey:kFileListKey];
	for (NSString *eachFile in [updateArchive fileNames]) {
		NSData *fileData = [updateArchive readWithFileName:eachFile maxLength:kMaxFileLength];

		BOOL isDir = [eachFile hasSuffix:@"/"];
		if (isDir)
			eachFile = [eachFile substringToIndex:[eachFile length] - 1];

		NSDictionary *fileAttrs = nil;
		NSDictionary *fileInfo = [fileList objectForKey:eachFile];
		NSString *fileType = fileInfo != nil ? [fileInfo objectForKey:kFileInfoType] : nil;
		NSNumber *fileMod = fileInfo != nil ? [fileInfo objectForKey:kFileInfoMod] : nil;
		if (fileMod != nil)
			fileAttrs = [NSDictionary dictionaryWithObject:fileMod forKey:NSFilePosixPermissions];

		NSString *fileDestination = destination;
		for (NSString *eachComponent in [eachFile pathComponents]) {
			fileDestination = [fileDestination stringByAppendingPathComponent:eachComponent];
		}

		if ([fileType isEqualToString:kFileSelf] || [fileType isEqualToString:kFileDelete])
			continue;

		if ([fileType isEqualToString:kFileDirectory] || isDir)
			[fm createDirectoryAtPath:fileDestination withIntermediateDirectories:YES
				       attributes:fileAttrs error:NULL];
		else
			[fm createFileAtPath:fileDestination contents:fileData attributes:fileAttrs];
	}
	return YES;
}

@end
