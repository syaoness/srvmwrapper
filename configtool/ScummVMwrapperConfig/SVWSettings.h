/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWSettings.h                                                                                 *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************
 * $Id::                                                                     $: SVN Info                           *
 * $Date::                                                                   $: Last modification                  *
 * $Author::                                                                 $: Last modification author           *
 * $Revision::                                                               $: SVN Revision                       *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>


@interface SVWSettings : NSObject {
	NSString *gameName;
	NSString *gameID;
	BOOL saveIntoHome;
	BOOL fullScreenMode;
	BOOL aspectRatioCorrectionEnabled;
	NSString *gfxMode;
	BOOL subtitlesEnabled;
	NSString *gameLanguage;
	int musicVolume;
	int sfxVolume;
	int speechVolume;
	BOOL iconChanged;
	NSImage *gameIcon;
	NSString *gameIconPath;

	NSArray *allGameIDs;
	NSArray *allGFXModes;
	NSArray *allGameLanguages;
}

- (void)loadData;
- (void)saveData;

- (void)resetDefaultValues;

@property (copy) NSString *gameName;
@property (copy) NSString *gameID;
@property (assign, getter=isSaveIntoHome) BOOL saveIntoHome;
@property (assign, getter=isFullScreenMode) BOOL fullScreenMode;
@property (assign, getter=isAspectRatioCorrectionEnabled) BOOL aspectRatioCorrectionEnabled;
@property (copy) NSString *gfxMode;
@property (assign, getter=isSubtitlesEnabled) BOOL subtitlesEnabled;
@property (copy) NSString *gameLanguage;
@property (assign) int musicVolume;
@property (assign) int sfxVolume;
@property (assign) int speechVolume;
@property (assign, getter=isIconChanged) BOOL iconChanged;
@property (copy) NSImage *gameIcon;
@property (copy) NSString *gameIconPath;

@property (nonatomic, readonly) NSArray *allGameIDs;
@property (nonatomic, readonly) NSArray *allGFXModes;
@property (nonatomic, readonly) NSArray *allGameLanguages;

@end
