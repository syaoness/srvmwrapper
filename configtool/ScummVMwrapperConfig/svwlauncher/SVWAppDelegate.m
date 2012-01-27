//
//  SVWAppDelegate.m
//  svwlauncher
//
//  Created by Emanuele Alimonda on 2012-01-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SVWAppDelegate.h"

#pragma mark Constants
NSString * const kCFBundleDisplayName        = @"CFBundleDisplayName";
NSString * const kCFBundleName               = @"CFBundleName";
NSString * const kSVWFullScreen              = @"SVWFullScreen";
NSString * const kSVWAspectRatio             = @"SVWAspectRatio";
NSString * const kSVWGFXMode                 = @"SVWGFXMode";
NSString * const kSVWEnableSubtitles         = @"SVWEnableSubtitles";
NSString * const kSVWLanguage                = @"SVWLanguage";
NSString * const kSVWMusicVolume             = @"SVWMusicVolume";
NSString * const kSVWSFXVolume               = @"SVWSFXVolume";
NSString * const kSVWSpeechVolume            = @"SVWSpeechVolume";
NSString * const kSVWEngineType              = @"SVWEngineType";
NSString * const kSVWExtraArguments          = @"SVWExtraArguments";
NSString * const kSVWEnableSw3DRenderer      = @"SVWEnableSw3DRenderer";
NSString * const kSVWEnableFpsCounter        = @"SVWEnableFpsCounter";
NSString * const kSVWEnableSpeech            = @"SVWEnableSpeech";

NSString * const kSavesDir                   = @"%@/saves";
NSString * const kGameDir                    = @"%@/game";
NSString * const kSavesPlaceholder           = @"%@/saves/.dontdeletethis";

NSString * const kScummVMExe                 = @"scummvm";
NSString * const kResidualExe                = @"residual";
NSString * const kConfigToolName             = @"ScummVMWrapperConfig.app";

NSUInteger const kEngineTypeScummVM          = 0;
NSUInteger const kEngineTypeResidual         = 1;

@implementation SVWAppDelegate

#pragma mark -
#pragma mark Object creation, initialization, desctruction
- (id)init {
	self = [super init];
	if (self) {
		loaded = NO;
//		engineType = kEngineTypeScummVM;
//		gameID = [[NSString alloc] initWithString:@""];
//		fullScreenMode = NO;
//		aspectRatioCorrectionEnabled = NO;
//		gfxMode = [[NSString alloc] initWithString:@""];
//		subtitlesEnabled = YES;
//		gameLanguage = [[NSString alloc] initWithString:@""];
//		musicVolume = 192;
//		sfxVolume = 192;
//		speechVolume = 192;
//		extraArguments = [[NSString alloc] initWithString:@""];
//		sw3DRenderer = NO;
//		fpsCounterEnabled = NO;
//		speechEnabled = YES;
	}
	return self;
}

- (void)dealloc {
//	[gameID release];
//	[gfxMode release];
//	[gameLanguage release];
//	[extraArguments release];
	
	[super dealloc];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
#pragma unused (aNotification)
	[self setConfigRun:NO];
	[self setConfigToolFound:NO];

	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	NSFileManager *fm = [NSFileManager defaultManager];

	// App bundle sanity check
	if (![bundlePath hasSuffix:@".app"]
	    || ![fm fileExistsAtPath:[bundlePath stringByAppendingPathComponent:@"Contents/MacOS"]]) {
		NSLog(@"This application must be run from an Application Bundle.  Aborting.");
		[NSApp terminate:self]; // TODO: Check if it works
	}
	
	if ([fm fileExistsAtPath:[bundlePath stringByAppendingPathComponent:@"ScummVMWrapperConfig.app"]])
		[self setConfigToolFound:YES];

	if ([self isConfigToolFound]) {
		CGEventRef event = CGEventCreate(NULL);
		CGEventFlags modifiers = CGEventGetFlags(event);
		CFRelease(event);
		if ((modifiers&kCGEventFlagMaskAlternate) == kCGEventFlagMaskAlternate
		    || (modifiers&kCGEventFlagMaskSecondaryFn) == kCGEventFlagMaskSecondaryFn) {
			[self setConfigRun:YES];
		}
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#pragma unused (aNotification)
	if ([self isConfigRun]) {
		[self runConfig];
		[NSApp terminate:self];
	}
	
	[self loadData];
	
	if (![self isLoaded]) {
		NSLog(@"Unable to load settings.  Aborting.");
		[self runConfig];
		[NSApp terminate:self];
	}
	
	NSMutableArray *args = [NSMutableArray array];
	
	[args addObject:[NSString stringWithFormat:@"--savepath=%@",
			 [NSString stringWithFormat:kSavesDir, [[NSBundle mainBundle] resourcePath]]]];
	[args addObject:[NSString stringWithFormat:@"--path=%@",
			 [NSString stringWithFormat:kGameDir, [[NSBundle mainBundle] resourcePath]]]];
	
	if ([self isFullScreenMode])
		[args addObject:@"--fullscreen"];
	
	if ([self gameLanguage] != nil && [[self gameLanguage] length] > 0)
		[args addObject:[@"--language=" stringByAppendingString:[self gameLanguage]]];
	
	NSString *engineExe = nil;
	NSUInteger range = 0;
	switch ([self engineType]) {
		case kEngineTypeScummVM:
			engineExe = kScummVMExe;
			range = 255;
			if ([self isSubtitlesEnabled])
				[args addObject:@"--subtitles"];
			if ([self isAspectRatioCorrectionEnabled])
				[args addObject:@"--aspect-ratio"];
			if ([self gfxMode] != nil && [[self gfxMode] length] > 0)
				[args addObject:[@"--gfx-mode=" stringByAppendingString:[self gfxMode]]];
			if (![self isFullScreenMode])
				[args addObject:@"--no-fullscreen"];
			break;
		case kEngineTypeResidual:
			engineExe = kResidualExe;
			range = 127;
			if ([self isFpsCounterEnabled])
				[args addObject:@"--show-fps=true"];
			else
				[args addObject:@"--show-fps=false"];
			if ([self isSw3DRenderer])
				[args addObject:@"--soft-renderer=true"];
			else
				[args addObject:@"--soft-renderer=false"];
			int speechMode = 0;
			if ([self isSubtitlesEnabled])
				speechMode |= 1;
			if ([self isSpeechEnabled])
				speechMode |= 2;
			[args addObject:[NSString stringWithFormat:@"--speech-mode=%d", speechMode]];
			break;
	}
	
	if ([self musicVolume] <= range)
		[args addObject:[NSString stringWithFormat:@"--music-volume=%ul", (unsigned long)[self musicVolume]]];
	
	if ([self sfxVolume] <= range)
		[args addObject:[NSString stringWithFormat:@"--sfx-volume=%ul", (unsigned long)[self sfxVolume]]];
	
	if ([self speechVolume] <= range)
		[args addObject:[NSString stringWithFormat:@"--speech-volume=%ul", (unsigned long)[self speechVolume]]];
	
	engineExe = [[NSBundle mainBundle] pathForAuxiliaryExecutable:engineExe];
	if (engineExe == nil) {
		NSLog(@"Can't find engine.  Aborting.");
		[self runConfig];
		[NSApp terminate:self];
	}
	
	if ([self extraArguments] != nil && [[self extraArguments] length] > 0)
		[args addObjectsFromArray:[[self extraArguments] componentsSeparatedByString:@" "]];
	
	[args addObject:[self gameID]];
	
	NSLog(@"ScummvmWrapper: Starting %@", [self gameID]);
	
	// Run Engine
	NSTask *engineTask = [[NSTask alloc] init];
	[engineTask setArguments:args];
//	[engineTask setCurrentDirectoryPath:nil];
//	[engineTask setEnvironment:nil];
	[engineTask setLaunchPath:engineExe];
	[engineTask launch];
	[engineTask waitUntilExit];
	int status = [engineTask terminationStatus];
	
	if (status == 0)
		NSLog(@"ScummvmWrapper: Finished %@", [self gameID]);
	else
		NSLog(@"ScummvmWrapper: Aborted %@", [self gameID]);
	[engineTask release];

	[NSApp terminate: nil];
}

- (BOOL)runConfig {
	if (![self isConfigToolFound])
		return NO;
	return [[NSWorkspace sharedWorkspace] openFile:[[[NSBundle mainBundle] bundlePath]
							stringByAppendingPathComponent:kConfigToolName]];
}

#pragma mark Load
- (BOOL)loadData {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[[[[NSBundle mainBundle] bundlePath]
									   stringByAppendingPathComponent:@"Contents"]
									  stringByAppendingPathComponent:@"Info.plist"]];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	[self resetDefaultValues];
	
	if (prefs != nil && [prefs objectForKey:kCFBundleName] != nil) {
		[self setEngineType:[[prefs objectForKey:kSVWEngineType] unsignedIntegerValue]];
		[self setGameID:[prefs objectForKey:kCFBundleName]];
		[self setFullScreenMode:[[prefs valueForKey:kSVWFullScreen] boolValue]];
		[self setAspectRatioCorrectionEnabled:[[prefs valueForKey:kSVWAspectRatio] boolValue]];
		[self setGfxMode:[prefs objectForKey:kSVWGFXMode]];
		[self setSubtitlesEnabled:[[prefs valueForKey:kSVWEnableSubtitles] boolValue]];
		[self setGameLanguage:[prefs objectForKey:kSVWLanguage]];
		[self setMusicVolume:[[prefs valueForKey:kSVWMusicVolume] unsignedIntegerValue]];
		[self setSfxVolume:[[prefs valueForKey:kSVWSFXVolume] unsignedIntegerValue]];
		[self setSpeechVolume:[[prefs valueForKey:kSVWSpeechVolume] unsignedIntegerValue]];
		[self setExtraArguments:[prefs valueForKey:kSVWExtraArguments]];
		[self setSw3DRenderer:[[prefs valueForKey:kSVWEnableSw3DRenderer] boolValue]];
		[self setFpsCounterEnabled:[[prefs valueForKey:kSVWEnableFpsCounter] boolValue]];
		[self setSpeechEnabled:[[prefs valueForKey:kSVWEnableSpeech] boolValue]];
	}
	
	if ((![fm fileExistsAtPath:[NSString stringWithFormat:kSavesPlaceholder, [[NSBundle mainBundle] resourcePath]]])) {
		[fm removeItemAtPath:[NSString stringWithFormat:kSavesDir, [[NSBundle mainBundle] resourcePath]]
			       error:nil];
		// TODO: Create directory if it doesn't exist
		// TODO: Create symlink
		/*	if [ ! -f "${SAVEPATH}/.dontdeletethis" ]; then
		 mkdir -p "${HOME}/Library/ScummvmSaveGame/${GAME_ID}" > /dev/null 2>&1
		 /bin/ln -sfh "${HOME}/Library/ScummvmSaveGame/${GAME_ID}" "${SAVEPATH}" > /dev/null 2>&1
		 fi
		 */
	}
	
	[self setLoaded:(prefs != nil && [prefs objectForKey:kCFBundleName] != nil)];
	return [self isLoaded];
}

#pragma mark Setters and Getters
- (void)resetDefaultValues {
	[self setLoaded:NO];
	[self setEngineType:kEngineTypeScummVM];
	[self setGameID:@""];
	[self setFullScreenMode:NO];
	[self setAspectRatioCorrectionEnabled:NO];
	[self setGfxMode:[NSString stringWithString:@""]];
	[self setSubtitlesEnabled:YES];
	[self setGameLanguage:@""];
	[self setMusicVolume:192];
	[self setSfxVolume:192];
	[self setSpeechVolume:192];
	[self setSw3DRenderer:NO];
	[self setFpsCounterEnabled:NO];
	[self setSpeechEnabled:YES];
	[self setExtraArguments:[NSString stringWithString:@""]];
}

#pragma mark -
#pragma mark Properties
@synthesize configRun;
@synthesize configToolFound;

@synthesize loaded;
@synthesize engineType;

#pragma mark Common
@synthesize gameID;
@synthesize fullScreenMode;
@synthesize gameLanguage;
@synthesize subtitlesEnabled;
@synthesize extraArguments;
@synthesize musicVolume;
@synthesize sfxVolume;
@synthesize speechVolume;

#pragma mark ScummVM
@synthesize aspectRatioCorrectionEnabled;
@synthesize gfxMode;

#pragma mark Residual
@synthesize sw3DRenderer;
@synthesize fpsCounterEnabled;
@synthesize speechEnabled;

@end







/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWLauncher                                               *
 *******************************************************************************************************************
 * File:             main.m                                                                                        *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

