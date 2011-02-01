//
//  SVWSettings.m
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-12-09.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import "SVWSettings.h"


@implementation SVWSettings

#pragma mark Properties

@synthesize gameName;
@synthesize gameID;
@synthesize saveIntoHome;
@synthesize fullScreenMode;
@synthesize aspectRatioCorrection;
@synthesize gfxMode;
@synthesize enableSubtitles;
@synthesize gameLanguage;
@synthesize musicVolume;
@synthesize sfxVolume;
@synthesize speechVolume;
@synthesize iconChanged;
@synthesize gameIcon;
@synthesize gameIconPath;

#pragma mark Object creation, initialization, desctruction

- (id) init {
	self = [super init];
	
	gameName = nil;
	gameID = nil;
	saveIntoHome = YES;
	fullScreenMode = NO;
	aspectRatioCorrection = NO;
	gfxMode = nil;
	enableSubtitles = YES;
	gameLanguage = nil;
	musicVolume = 0;
	sfxVolume = 0;
	speechVolume = 0;
	iconChanged = NO;
	gameIcon = nil;
	gameIconPath = nil;
	
	[self loadData];
	
	return self;
}

- (void) dealloc {
	[self saveData];
	
	[gameName release];
	[gameID release];
	[gfxMode release];
	[gameLanguage release];
	[gameIcon release];
	
	[super dealloc];
}

#pragma mark Load and Save

- (void) loadData {
	NSBundle *mainBundle;
	NSDictionary *prefs;
	NSFileManager *filemanager;
	
	mainBundle = [NSBundle mainBundle];
	prefs = [NSDictionary dictionaryWithContentsOfFile:
		 [NSString stringWithFormat:@"%@/../Contents/Info.plist", [mainBundle bundlePath]]];
	filemanager = [NSFileManager defaultManager];
	
	[self setGameName:nil];
	[self setGameID:nil];
	[self setFullScreenMode:NO];
	[self setAspectRatioCorrection:NO];
	[self setGfxMode:nil];
	[self setEnableSubtitles:YES];
	[self setGameLanguage:nil];
	[self setMusicVolume:-1];
	[self setSfxVolume:-1];
	[self setSpeechVolume:-1];
	[self setGameIcon:nil];
	[self setGameIconPath:nil];
	if( prefs ) {
		[self setGameName:[prefs objectForKey:@"CFBundleDisplayName"]];
		[self setGameID:[prefs objectForKey:@"CFBundleName"]];
		[self setFullScreenMode:[[prefs valueForKey:@"SVWFullScreen"] boolValue]];
		[self setAspectRatioCorrection:[[prefs valueForKey:@"SVWAspectRatio"] boolValue]];
		[self setGfxMode:[prefs objectForKey:@"SVWGFXMode"]];
		[self setEnableSubtitles:[[prefs valueForKey:@"SVWEnableSubtitles"] boolValue]];
		[self setGameLanguage:[prefs objectForKey:@"SVWLanguage"]];
		[self setMusicVolume:[[prefs valueForKey:@"SVWMusicVolume"] intValue]];
		[self setSfxVolume:[[prefs valueForKey:@"SVWSFXVolume"] intValue]];
		[self setSpeechVolume:[[prefs valueForKey:@"SVWSpeechVolume"] intValue]];
	}
	// FIXME: Move error checking and defaults to the setters
	if( !prefs || ![self gfxMode] )
		[self setGfxMode:@"2x"];
	if( !prefs || ![self gameLanguage] )
		[self setGameLanguage:@"en"];
	if( !prefs || [self musicVolume] < 0 )
		[self setMusicVolume:192];
	if( !prefs || [self sfxVolume] < 0 )
		[self setSfxVolume:192];
	if( !prefs || [self speechVolume] < 0 )
		[self setSpeechVolume:192];
	
	[self setSaveIntoHome:![filemanager fileExistsAtPath:
			[NSString stringWithFormat:@"%@/../Contents/Resources/saves/.dontdeletethis",
			[mainBundle bundlePath]]]];
	[self setGameIcon:[[[NSImage alloc] initWithContentsOfFile:
			[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns", [mainBundle bundlePath]]]
			autorelease]];
	
	[self setIconChanged:NO];
}

- (void) saveData {
	NSBundle *mainBundle;
	NSDictionary *oldprefs;
	NSMutableDictionary *prefs;
	NSFileManager *filemanager;
	
	mainBundle = [NSBundle mainBundle];
	oldprefs = [NSDictionary dictionaryWithContentsOfFile:
		    [NSString stringWithFormat:@"%@/../Contents/Info.plist", [mainBundle bundlePath]]];
	prefs = [NSMutableDictionary dictionaryWithDictionary:oldprefs];
	filemanager = [NSFileManager defaultManager];
	
	[prefs setObject:(gameName ? gameName : @"") forKey:@"CFBundleDisplayName"];
	[prefs setObject:(gameID ? gameID : @"") forKey:@"CFBundleName"];
	[prefs setObject:[NSString stringWithFormat:@"com.dotalux.scummwrapper.%@", gameID]
		  forKey:@"CFBundleIdentifier"];
	[prefs setObject:[NSNumber numberWithBool:fullScreenMode] forKey:@"SVWFullScreen"];
	[prefs setObject:[NSNumber numberWithBool:aspectRatioCorrection] forKey:@"SVWAspectRatio"];
	[prefs setObject:(gfxMode ? gfxMode : @"") forKey:@"SVWGFXMode"];
	[prefs setObject:[NSNumber numberWithBool:enableSubtitles] forKey:@"SVWEnableSubtitles"];
	[prefs setObject:(gameLanguage ? gameLanguage : @"") forKey:@"SVWLanguage"];
	[prefs setObject:[NSNumber numberWithInt:musicVolume] forKey:@"SVWMusicVolume"];
	[prefs setObject:[NSNumber numberWithInt:sfxVolume] forKey:@"SVWSFXVolume"];
	[prefs setObject:[NSNumber numberWithInt:speechVolume] forKey:@"SVWSpeechVolume"];
	
	if( saveIntoHome ) {
		[filemanager removeItemAtPath:[NSString stringWithFormat:@"%@/../Contents/Resources/saves",
					       [mainBundle bundlePath]] error:nil];
	} else {
		if( ![filemanager fileExistsAtPath:
		      [NSString stringWithFormat:@"%@/../Contents/Resources/saves/.dontdeletethis",
		       [mainBundle bundlePath]]] ) {
			      [filemanager removeItemAtPath:
			       [NSString stringWithFormat:@"%@/../Contents/Resources/saves",
				[mainBundle bundlePath]] error:nil];
		      }
		[filemanager createDirectoryAtPath:[NSString stringWithFormat:@"%@/../Contents/Resources/saves",
						    [mainBundle bundlePath]] withIntermediateDirectories:NO attributes:nil error:nil];
		[filemanager createFileAtPath:
		 [NSString stringWithFormat:@"%@/../Contents/Resources/saves/.dontdeletethis",
		  [mainBundle bundlePath]] contents:nil attributes:nil];
	}
	
	[prefs writeToFile:[NSString stringWithFormat:@"%@/../Contents/Info.plist", [mainBundle bundlePath]]
		atomically: YES];
	
	if( iconChanged && [self gameIconPath] ) {
		[filemanager removeItemAtPath:[NSString stringWithFormat:@"%@/../Contents/Resources/old.icns",
					       [mainBundle bundlePath]] error:nil];
		[filemanager moveItemAtPath:[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns",
					     [mainBundle bundlePath]] toPath:
		 [NSString stringWithFormat:@"%@/../Contents/Resources/old.icns",
		  [mainBundle bundlePath]] error:nil];
		[filemanager copyItemAtPath:[self gameIconPath]
				     toPath:[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns",
					     [mainBundle bundlePath]] error:nil];
	}
	[[NSApp mainWindow] setDocumentEdited:NO];
}

@end
