/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWSettings.m                                                                                 *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************
 * $Id::                                                                     $: SVN Info                           *
 * $Date::                                                                   $: Last modification                  *
 * $Author::                                                                 $: Last modification author           *
 * $Revision::                                                               $: SVN Revision                       *
 *******************************************************************************************************************/

#import "SVWSettings.h"

/*******************************************************************************************************************/
#pragma mark Constants
NSString * const kCFBundleDisplayName = @"CFBundleDisplayName";
NSString * const kCFBundleName = @"CFBundleName";
NSString * const kCFBundleIdentifier = @"CFBundleIdentifier";
NSString * const kSVWFullScreen = @"SVWFullScreen";
NSString * const kSVWAspectRatio = @"SVWAspectRatio";
NSString * const kSVWGFXMode = @"SVWGFXMode";
NSString * const kSVWEnableSubtitles = @"SVWEnableSubtitles";
NSString * const kSVWLanguage = @"SVWLanguage";
NSString * const kSVWMusicVolume = @"SVWMusicVolume";
NSString * const kSVWSFXVolume = @"SVWSFXVolume";
NSString * const kSVWSpeechVolume = @"SVWSpeechVolume";

NSString * const kGameIcns = @"%@/game.icns";
NSString * const kOldIcns = @"%@/old.icns";
NSString * const kSavesDir = @"%@/saves";
NSString * const kSavesPlaceholder = @"%@/saves/.dontdeletethis";
NSString * const kInfoPlistPath = @"%@/Contents/Info.plist";

/*******************************************************************************************************************/
@implementation SVWSettings

/*******************************************************************************************************************/
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

/*******************************************************************************************************************/
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

/*******************************************************************************************************************/
#pragma mark Load and Save
- (void) loadData {
	NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
			stringByDeletingLastPathComponent]];
	NSDictionary *prefs = [NSDictionary dictionaryWithDictionary:[wrapperBundle infoDictionary]];
	NSFileManager *filemanager = [NSFileManager defaultManager];
	
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
		[self setGameName:[prefs objectForKey:kCFBundleDisplayName]];
		[self setGameID:[prefs objectForKey:kCFBundleName]];
		[self setFullScreenMode:[[prefs valueForKey:kSVWFullScreen] boolValue]];
		[self setAspectRatioCorrection:[[prefs valueForKey:kSVWAspectRatio] boolValue]];
		[self setGfxMode:[prefs objectForKey:kSVWGFXMode]];
		[self setEnableSubtitles:[[prefs valueForKey:kSVWEnableSubtitles] boolValue]];
		[self setGameLanguage:[prefs objectForKey:kSVWLanguage]];
		[self setMusicVolume:[[prefs valueForKey:kSVWMusicVolume] intValue]];
		[self setSfxVolume:[[prefs valueForKey:kSVWSFXVolume] intValue]];
		[self setSpeechVolume:[[prefs valueForKey:kSVWSpeechVolume] intValue]];
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
	
	[self setSaveIntoHome:![filemanager fileExistsAtPath:[NSString stringWithFormat:kSavesPlaceholder,
			[wrapperBundle resourcePath]]]];
	[self setGameIcon:[[[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:kGameIcns,
			[wrapperBundle resourcePath]]] autorelease]];
	[self setIconChanged:NO];
}

- (void) saveData {
	NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
			stringByDeletingLastPathComponent]];
	NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithDictionary:[wrapperBundle infoDictionary]];
	NSFileManager *filemanager = [NSFileManager defaultManager];
	
	// TODO: Handle defaults in getters
	[prefs setObject:(gameName ? gameName : @"") forKey:kCFBundleDisplayName];
	[prefs setObject:(gameID ? gameID : @"") forKey:kCFBundleName];
	[prefs setObject:[NSString stringWithFormat:@"com.dotalux.scummwrapper.%@", gameID] forKey:kCFBundleIdentifier];
	[prefs setObject:[NSNumber numberWithBool:fullScreenMode] forKey:kSVWFullScreen];
	[prefs setObject:[NSNumber numberWithBool:aspectRatioCorrection] forKey:kSVWAspectRatio];
	[prefs setObject:(gfxMode ? gfxMode : @"") forKey:kSVWGFXMode];
	[prefs setObject:[NSNumber numberWithBool:enableSubtitles] forKey:kSVWEnableSubtitles];
	[prefs setObject:(gameLanguage ? gameLanguage : @"") forKey:kSVWLanguage];
	[prefs setObject:[NSNumber numberWithInt:musicVolume] forKey:kSVWMusicVolume];
	[prefs setObject:[NSNumber numberWithInt:sfxVolume] forKey:kSVWSFXVolume];
	[prefs setObject:[NSNumber numberWithInt:speechVolume] forKey:kSVWSpeechVolume];
	
	if( saveIntoHome ) {
		[filemanager removeItemAtPath:[NSString stringWithFormat:kSavesDir, [wrapperBundle resourcePath]]
				error:nil];
	} else {
		if( ![filemanager fileExistsAtPath:[NSString stringWithFormat:kSavesPlaceholder, [wrapperBundle
				resourcePath]]] ) {
			[filemanager removeItemAtPath:[NSString stringWithFormat:kSavesDir, [wrapperBundle
					resourcePath]] error:nil];
		}
		[filemanager createDirectoryAtPath:[NSString stringWithFormat:kSavesDir, [wrapperBundle resourcePath]]
				withIntermediateDirectories:NO attributes:nil error:nil];
		[filemanager createFileAtPath:[NSString stringWithFormat:kSavesPlaceholder, [wrapperBundle
				resourcePath]] contents:nil attributes:nil];
	}
	
	[prefs writeToFile:[NSString stringWithFormat:kInfoPlistPath, [wrapperBundle bundlePath]] atomically: YES];
	
	if( iconChanged && [self gameIconPath] ) {
		[filemanager removeItemAtPath:[NSString stringWithFormat:kOldIcns, [wrapperBundle resourcePath]]
				error:nil];
		[filemanager moveItemAtPath:[NSString stringWithFormat:kGameIcns, [wrapperBundle resourcePath]] toPath:
				[NSString stringWithFormat:kOldIcns, [wrapperBundle resourcePath]] error:nil];
		[filemanager copyItemAtPath:[self gameIconPath] toPath:[NSString stringWithFormat:kGameIcns,
				[wrapperBundle resourcePath]] error:nil];
	}
	[[NSApp mainWindow] setDocumentEdited:NO];
}

/*******************************************************************************************************************/
@end
