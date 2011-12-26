/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWSettings.h                                                                                 *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>

extern NSUInteger const kSaveGameLocationLibrary;
extern NSUInteger const kSaveGameLocationBundle;

@interface SVWSettings : NSObject {
	NSUInteger engineType;
	BOOL edited;
	NSArray *allGameIDs;
	NSArray *allGFXModes;
	NSArray *allGameLanguages;
	
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
		
	/// Version info
	NSString *wrapperVersion;
	NSString *scummVMVersion;
	NSString *residualVersion;

}

- (void)loadData;
- (void)saveData;

- (void)resetDefaultValues;

+ (NSString *)defaultIconPath;

#pragma mark Properties
@property (assign) NSUInteger engineType;
@property (assign, getter=isEdited) BOOL edited;
@property (nonatomic, readonly) NSArray *allGameIDs;
@property (nonatomic, readonly) NSArray *allGFXModes;
@property (nonatomic, readonly) NSArray *allGameLanguages;

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

#pragma mark Version Info
@property (retain, readonly) NSString *wrapperVersion;
@property (retain, readonly) NSString *scummVMVersion;
@property (retain, readonly) NSString *residualVersion;

@end
