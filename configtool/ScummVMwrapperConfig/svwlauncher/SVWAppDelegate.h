//
//  SVWAppDelegate.h
//  svwlauncher
//
//  Created by Emanuele Alimonda on 2012-01-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SVWAppDelegate : NSObject <NSApplicationDelegate> {
	BOOL configRun;
	BOOL configToolFound;
	
	BOOL loaded;
	NSUInteger engineType;
	
	/// Common
	NSString *gameID;
	BOOL fullScreenMode;
	NSString *gameLanguage;
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

#pragma mark -
#pragma mark Properties
@property (assign, getter=isConfigRun) BOOL configRun;
@property (assign, getter=isConfigToolFound) BOOL configToolFound;

@property (assign, getter=isLoaded) BOOL loaded;
@property (assign) NSUInteger engineType;

#pragma mark Common
@property (retain) NSString *gameID;
@property (assign, getter=isFullScreenMode) BOOL fullScreenMode;
@property (retain) NSString *gameLanguage;
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


//- (NSString *)systemCommand:(NSString *)command; //run system command with output returned
#pragma mark Methods
- (BOOL)runConfig;
- (BOOL)loadData;
- (void)resetDefaultValues;

@end
