/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWSettings.h                                                                                 *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>

#pragma mark Constants
extern NSUInteger const kSaveGameLocationLibrary;
extern NSUInteger const kSaveGameLocationBundle;
extern NSString * const kCFBundleShortVersionString;

#pragma mark Interface
@interface SVWSettings : NSObject {
	NSUInteger engineType;
	BOOL edited;
	NSArray *allScummGameIDs;
	NSArray *allResidualGameIDs;
	NSArray *allGameIDs;
	NSArray *allGFXModes;
	NSArray *allGameLanguages;
	NSImage *engineIcon;
	
	/// Common
	NSString *gameName;
	NSString *gameID;
	NSUInteger saveGameLocation;
	NSUInteger saveGameLocationOriginal;
	BOOL saveGameLocationEdited;
	BOOL fullScreenMode;
	NSString *gameLanguage;
	NSString *gameIconPath;
	NSString *extraArguments;
	BOOL subtitlesEnabled;
	NSUInteger musicVolume;
	NSUInteger sfxVolume;
	NSUInteger speechVolume;

	/// ScummVM
	BOOL aspectRatioCorrectionEnabled;
	NSString *gfxMode;
	
	/// Residual
	BOOL sw3DRenderer;
	BOOL fpsCounterEnabled;
	BOOL speechEnabled;
}

#pragma mark Methods
- (void)loadData;
- (void)saveData;

- (void)resetDefaultValues;

+ (NSString *)defaultIconPath;

#pragma mark -
#pragma mark Properties
@property (assign) NSUInteger engineType;
@property (assign, getter=isEdited) BOOL edited;
@property (nonatomic, readonly) NSArray *allScummGameIDs;
@property (nonatomic, readonly) NSArray *allResidualGameIDs;
@property (retain) NSArray *allGameIDs;
@property (nonatomic, readonly) NSArray *allGFXModes;
@property (nonatomic, readonly) NSArray *allGameLanguages;
@property (retain) NSImage *engineIcon;

#pragma mark Common
@property (retain) NSString *gameName;
@property (retain) NSString *gameID;
@property (assign) NSUInteger saveGameLocation;
@property (assign) NSUInteger saveGameLocationOriginal;
@property (assign) BOOL saveGameLocationEdited;
@property (assign, getter=isFullScreenMode) BOOL fullScreenMode;
@property (retain) NSString *gameLanguage;
@property (copy) NSString *gameIconPath;
@property (retain) NSString *extraArguments;
@property (assign, getter=isSubtitlesEnabled) BOOL subtitlesEnabled;
@property (assign) NSUInteger musicVolume;
@property (assign) NSUInteger sfxVolume;
@property (assign) NSUInteger speechVolume;

#pragma mark ScummVM
@property (assign, getter=isAspectRatioCorrectionEnabled) BOOL aspectRatioCorrectionEnabled;
@property (retain) NSString *gfxMode;

#pragma mark Residual
@property (assign, getter=isSw3DRenderer) BOOL sw3DRenderer;
@property (assign, getter=isFpsCounterEnabled) BOOL fpsCounterEnabled;
@property (assign, getter=isSpeechEnabled) BOOL speechEnabled;

@end
