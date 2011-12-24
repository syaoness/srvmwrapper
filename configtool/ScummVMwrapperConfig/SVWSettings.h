/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWSettings.h                                                                                 *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>


@interface SVWSettings : NSObject {
	NSString *gameName;
	NSString *gameID;

	BOOL fullScreenMode;
	BOOL aspectRatioCorrectionEnabled;
	NSString *gfxMode;
	BOOL subtitlesEnabled;
	NSString *gameLanguage;
	NSUInteger musicVolume;
	NSUInteger sfxVolume;
	NSUInteger speechVolume;

	BOOL saveIntoHome;
	BOOL iconChanged;
	NSImage *gameIcon;
	NSString *gameIconPath;

	NSArray *allGameIDs;
	NSArray *allGFXModes;
	NSArray *allGameLanguages;
	BOOL edited;
}

- (void)loadData;
- (void)saveData;

- (void)resetDefaultValues;

@property (retain) NSString *gameName;
@property (retain) NSString *gameID;

@property (assign, getter=isFullScreenMode) BOOL fullScreenMode;
@property (assign, getter=isAspectRatioCorrectionEnabled) BOOL aspectRatioCorrectionEnabled;
@property (retain) NSString *gfxMode;
@property (assign, getter=isSubtitlesEnabled) BOOL subtitlesEnabled;
@property (retain) NSString *gameLanguage;
@property (assign) NSUInteger musicVolume;
@property (assign) NSUInteger sfxVolume;
@property (assign) NSUInteger speechVolume;

@property (assign, getter=isSaveIntoHome) BOOL saveIntoHome;
@property (assign, getter=isIconChanged) BOOL iconChanged;
@property (copy) NSImage *gameIcon;
@property (copy) NSString *gameIconPath;
@property (assign, getter=isEdited) BOOL edited;

@property (nonatomic, readonly) NSArray *allGameIDs;
@property (nonatomic, readonly) NSArray *allGFXModes;
@property (nonatomic, readonly) NSArray *allGameLanguages;

@end
