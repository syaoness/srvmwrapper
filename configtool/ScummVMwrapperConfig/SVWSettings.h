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
	BOOL aspectRatioCorrection;
	NSString *gfxMode;
	BOOL enableSubtitles;
	NSString *gameLanguage;
	int musicVolume;
	int sfxVolume;
	int speechVolume;
	BOOL iconChanged;
	NSImage *gameIcon;
	NSString *gameIconPath;
}

- (void)loadData;
- (void)saveData;

@property (retain) NSString *gameName;
@property (retain) NSString *gameID;
@property (assign) BOOL saveIntoHome;
@property (assign) BOOL fullScreenMode;
@property (assign) BOOL aspectRatioCorrection;
@property (retain) NSString *gfxMode;
@property (assign) BOOL enableSubtitles;
@property (retain) NSString *gameLanguage;
@property (assign) int musicVolume;
@property (assign) int sfxVolume;
@property (assign) int speechVolume;
@property (assign) BOOL iconChanged;
@property (retain) NSImage *gameIcon; // TODO: Or copy?
@property (retain) NSString *gameIconPath;

@end
