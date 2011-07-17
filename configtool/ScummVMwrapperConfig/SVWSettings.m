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
@synthesize aspectRatioCorrectionEnabled;
@synthesize gfxMode;
@synthesize subtitlesEnabled;
@synthesize gameLanguage;
@synthesize musicVolume;
@synthesize sfxVolume;
@synthesize speechVolume;
@synthesize iconChanged;
@synthesize gameIcon;
@synthesize gameIconPath;

@synthesize allGameIDs;
@synthesize allGFXModes;
@synthesize allGameLanguages;

/*******************************************************************************************************************/
#pragma mark Object creation, initialization, desctruction
- (id) init {
	self = [super init];
	allGameIDs = [[NSArray alloc] initWithObjects:
			@"activity",		// Putt-Putt & Fatty Bear's Activity Pack
			@"agi",			// Sierra AGI game
			@"airport",		// Let's Explore the Airport with Buzzy
			@"arttime",		// Blue's Art Time Activities
			@"atlantis",		// Indiana Jones and the Fate of Atlantis
			@"balloon",		// Putt-Putt and Pep's Balloon-O-Rama
			@"baseball",		// Backyard Baseball
			@"baseball2001",	// Backyard Baseball 2001
			@"Baseball2003",	// Backyard Baseball 2003
			@"basketball",		// Backyard Basketball
			@"Blues123Time",	// Blue's 123 Time Activities
			@"BluesABCTime",	// Blue's ABC Time Activities
			@"BluesBirthday",	// Blue's Birthday Adventure
			@"BluesTreasureHunt",	// Blue's Treasure Hunt
			@"bra",			// The Big Red Adventure
			@"brstorm",		// Bear Stormin'
			@"catalog",		// Humongous Interactive Catalog
			@"chase",		// SPY Fox in Cheese Chase
			@"cine",		// Cinematique evo.1 engine game
			@"comi",		// The Curse of Monkey Island
			@"cruise",		// Cinematique evo.2 engine game
			@"dig",			// The Dig
			@"dimp",		// Demon in my Pocket
			@"dog",			// Putt-Putt and Pep's Dog on a Stick
			@"draci",		// Draci Historie
			@"drascula",		// Drascula: The Vampire Strikes Back
			@"elvira1",		// Elvira - Mistress of the Dark
			@"elvira2",		// Elvira II - The Jaws of Cerberus
			@"farm",		// Let's Explore the Farm with Buzzy
			@"fbear",		// Fatty Bear's Birthday Surprise
			@"fbpack",		// Fatty Bear's Fun Pack
			@"feeble",		// The Feeble Files
			@"football",		// Backyard Football
			@"football2002",	// Backyard Football 2002
			@"freddi",		// Freddi Fish 1: The Case of the Missing Kelp Seeds
			@"freddi2",		// Freddi Fish 2: The Case of the Haunted Schoolhouse
			@"freddi3",		// Freddi Fish 3: The Case of the Stolen Conch Shell
			@"freddi4",		// Freddi Fish 4: The Case of the Hogfish Rustlers of Briny Gulch
			@"freddicove",		// Freddi Fish 5: The Case of the Creature of Coral Cove
			@"FreddisFunShop",	// Freddi Fish's One-Stop Fun Shop
			@"ft",			// Full Throttle
			@"funpack",		// Putt-Putt's Fun Pack
			@"gob",			// Gob engine game
			@"groovie",		// Groovie engine game
			@"indy3",		// Indiana Jones and the Last Crusade
			@"hugo1",		// Hugo 1: Hugo's House of Horrors
			@"hugo2",		// Hugo 2: Whodunit?
			@"hugo3",		// Hugo 3: Jungle of Doom
			@"jumble",		// Jumble
			@"jungle",		// Let's Explore the Jungle with Buzzy
			@"kyra1",		// The Legend of Kyrandia
			@"kyra2",		// The Legend of Kyrandia: The Hand of Fate
			@"kyra3",		// The Legend of Kyrandia: Malcolm's Revenge
			@"loom",		// Loom
			@"lost",		// Pajama Sam's Lost & Found
			@"lure",		// Lure of the Temptress
			@"made",		// MADE engine game
			@"maniac",		// Maniac Mansion
			@"maze",		// Freddi Fish and Luther's Maze Madness
			@"mohawk",		// Mohawk Game
			@"monkey",		// The Secret of Monkey Island
			@"monkey2",		// Monkey Island 2: LeChuck's Revenge
			@"moonbase",		// Moonbase Commander
			@"mustard",		// SPY Fox in Hold the Mustard
			@"nippon",		// Nippon Safes Inc.
			@"pajama",		// Pajama Sam 1: No Need to Hide When It's Dark Outside
			@"pajama2",		// Pajama Sam 2: Thunder and Lightning Aren't so Frightening
			@"pajama3",		// Pajama Sam 3: You Are What You Eat From Your Head to Your Feet
			@"parallaction",	// Parallaction engine game
			@"pass",		// Passport to Adventure
			@"pjgames",		// Pajama Sam: Games to Play on Any Day
			@"pn",			// Personal Nightmare
			@"puttcircus",		// Putt-Putt Joins the Circus
			@"puttmoon",		// Putt-Putt Goes to the Moon
			@"puttputt",		// Putt-Putt Joins the Parade
			@"puttrace",		// Putt-Putt Enters the Race
			@"PuttsFunShop",	// Putt-Putt's One-Stop Fun Shop
			@"putttime",		// Putt-Putt Travels Through Time
			@"puttzoo",		// Putt-Putt Saves the Zoo
			@"puzzle",		// NoPatience
			@"queen",		// Flight of the Amazon Queen
			@"readtime",		// Blue's Reading Time Activities
			@"saga",		// SAGA Engine game
			@"samnmax",		// Sam & Max Hit the Road
			@"SamsFunShop",		// Pajama Sam's One-Stop Fun Shop
			@"sci",			// Sierra SCI Game
			@"simon1",		// Simon the Sorcerer 1
			@"simon2",		// Simon the Sorcerer 2
			@"sky",			// Beneath a Steel Sky
			@"soccer",		// Backyard Soccer
			@"Soccer2004",		// Backyard Soccer 2004
			@"SoccerMLS",		// Backyard Soccer MLS Edition
			@"socks",		// Pajama Sam's Sock Works
			@"spyfox",		// SPY Fox 1: Dry Cereal
			@"spyfox2",		// SPY Fox 2: Some Assembly Required
			@"spyozon",		// SPY Fox 3: Operation Ozone
			@"swampy",		// Swampy Adventures
			@"sword1",		// Broken Sword: The Shadow of the Templars
			@"sword1demo",		// Broken Sword: The Shadow of the Templars (Demo)
			@"sword1mac",		// Broken Sword: The Shadow of the Templars (Mac)
			@"sword1macdemo",	// Broken Sword: The Shadow of the Templars (Mac demo)
			@"sword1psx",		// Broken Sword: The Shadow of the Templars (PlayStation)
			@"sword1psxdemo",	// Broken Sword: The Shadow of the Templars (PlayStation demo)
			@"sword2",		// Broken Sword II: The Smoking Mirror
			@"sword2alt",		// Broken Sword II: The Smoking Mirror (alt)
			@"sword2demo",		// Broken Sword II: The Smoking Mirror (Demo)
			@"sword2psx",		// Broken Sword II: The Smoking Mirror (PlayStation)
			@"sword2psxdemo",	// Broken Sword II: The Smoking Mirror (PlayStation/Demo)
			@"teenagent",		// Teen Agent
			@"tentacle",		// Day of the Tentacle
			@"thinker1",		// Big Thinkers First Grade
			@"thinkerk",		// Big Thinkers Kindergarten
			@"tinsel",		// Tinsel engine game
			@"toon",		// Toonstruck
			@"touche",		// Touche: The Adventures of the Fifth Musketeer
			@"tucker",		// Bud Tucker in Double Trouble
			@"water",		// Freddi Fish and Luther's Water Worries
			@"waxworks",		// Waxworks
			@"zak",			// Zak McKracken and the Alien Mindbenders
			nil];
	allGFXModes = [[NSArray alloc] initWithObjects:
			@"1x",
			@"2x",
			@"3x",
			@"2xsai",
			@"super2xsai",
			@"supereagle",
			@"advmame2x",
			@"advmame3x",
			@"hq2x",
			@"hq3x",
			@"tv2x",
			@"dotmatrix",
			nil];
	allGameLanguages = [[NSArray alloc] initWithObjects:
			@"en",
			@"de",
			@"fr",
			@"it",
			@"pt",
			@"es",
			@"jp",
			@"zh",
			@"kr",
			@"se",
			@"gb",
			@"hb",
			@"ru",
			@"cz",
			nil];
	if( self ) {
		[self loadData];
	}
	
	return self;
}

- (void) dealloc {
	[self saveData];
	
	[gameName release];
	[gameID release];
	[gfxMode release];
	[gameLanguage release];
	[gameIcon release];
	
	[allGameIDs release];
	[allGFXModes release];
	[allGameLanguages release];
	
	[super dealloc];
}

/*******************************************************************************************************************/
#pragma mark Load and Save
- (void) loadData {
	NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
			stringByDeletingLastPathComponent]];
	NSDictionary *prefs = [NSDictionary dictionaryWithDictionary:[wrapperBundle infoDictionary]];
	NSFileManager *filemanager = [NSFileManager defaultManager];
	
	[self resetDefaultValues];
	if( prefs ) {
		[self setGameName:[prefs objectForKey:kCFBundleDisplayName]];
		[self setGameID:[prefs objectForKey:kCFBundleName]];
		[self setFullScreenMode:[[prefs valueForKey:kSVWFullScreen] boolValue]];
		[self setAspectRatioCorrectionEnabled:[[prefs valueForKey:kSVWAspectRatio] boolValue]];
		[self setGfxMode:[prefs objectForKey:kSVWGFXMode]];
		[self setSubtitlesEnabled:[[prefs valueForKey:kSVWEnableSubtitles] boolValue]];
		[self setGameLanguage:[prefs objectForKey:kSVWLanguage]];
		[self setMusicVolume:[[prefs valueForKey:kSVWMusicVolume] intValue]];
		[self setSfxVolume:[[prefs valueForKey:kSVWSFXVolume] intValue]];
		[self setSpeechVolume:[[prefs valueForKey:kSVWSpeechVolume] intValue]];
	}
	
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
	
	[prefs setObject:[self gameName] forKey:kCFBundleDisplayName];
	[prefs setObject:[self gameID] forKey:kCFBundleName];
	[prefs setObject:[NSString stringWithFormat:@"com.dotalux.scummwrapper.%@", [self gameID]]
			forKey:kCFBundleIdentifier];
	[prefs setObject:[NSNumber numberWithBool:[self isFullScreenMode]] forKey:kSVWFullScreen];
	[prefs setObject:[NSNumber numberWithBool:[self isAspectRatioCorrectionEnabled]] forKey:kSVWAspectRatio];
	[prefs setObject:[self gfxMode] forKey:kSVWGFXMode];
	[prefs setObject:[NSNumber numberWithBool:[self isSubtitlesEnabled]] forKey:kSVWEnableSubtitles];
	[prefs setObject:[self gameLanguage] forKey:kSVWLanguage];
	[prefs setObject:[NSNumber numberWithInt:[self musicVolume]] forKey:kSVWMusicVolume];
	[prefs setObject:[NSNumber numberWithInt:[self sfxVolume]] forKey:kSVWSFXVolume];
	[prefs setObject:[NSNumber numberWithInt:[self speechVolume]] forKey:kSVWSpeechVolume];
	
	if( [self isSaveIntoHome] ) {
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
	
	if( [self isIconChanged] && [self gameIconPath] ) {
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
#pragma mark Setters and Getters
- (void)resetDefaultValues {
	gameName = nil;
	gameID = nil;
	saveIntoHome = YES;
	fullScreenMode = NO;
	aspectRatioCorrectionEnabled = NO;
	gfxMode = nil;
	subtitlesEnabled = YES;
	gameLanguage = nil;
	musicVolume = -1;
	sfxVolume = -1;
	speechVolume = -1;
	iconChanged = NO;
	gameIcon = nil;
	gameIconPath = nil;
}

/** (copy) NSString *gameName */
- (NSString *)gameName {
	if( !gameName )
		return [NSString stringWithString:@""];
	return [[gameName copy] autorelease];
}

/** (copy) NSString *gameID */
- (NSString *)gameID {
	if( !gameID )
		return [NSString stringWithString:@""];
	return [[gameID copy] autorelease];
}

/** (assign) BOOL saveIntoHome */

/** (assign) BOOL fullScreenMode */

/** (assign) BOOL aspectRatioCorrectionEnabled */

/** (copy) NSString *gfxMode */
- (void)setGfxMode:(NSString *)newValue {
	if( gfxMode )
		[gfxMode release];
	for( NSString *eachItem in [self allGFXModes] ) {
		if( [eachItem isEqualToString:newValue] ) {
			gfxMode = [newValue copy];
			return;
		}
	}
	gfxMode = nil;
}

- (NSString *)gfxMode {
	if( !gfxMode )
		return [NSString stringWithString:@"2x"];
	return [[gfxMode copy] autorelease];
}

/** (assign) BOOL subtitlesEnabled */

/** (copy) NSString *gameLanguage */
- (void)setGameLanguage:(NSString *)newValue {
	if( gameLanguage )
		[gameLanguage release];
	for( NSString *eachItem in [self allGameLanguages] ) {
		if( [eachItem isEqualToString:newValue] ) {
			gameLanguage = [newValue copy];
			return;
		}
	}
	gameLanguage = nil;
}

- (NSString *)gameLanguage {
	if( !gameLanguage )
		return [NSString stringWithString:@"en"];
	return [[gameLanguage copy] autorelease];
}

/** (assign) int musicVolume */
- (void) setMusicVolume:(int)newValue {
	if( newValue < 0 || newValue > 255 ) {
		musicVolume = -1;
		return;
	}
	musicVolume = newValue;
}

- (int)musicVolume {
	if( musicVolume < 0 || musicVolume > 255 )
		return 192;
	return musicVolume;
}

/** (assign) int sfxVolume */
- (void) setSfxVolume:(int)newValue {
	if( newValue < 0 || newValue > 255 ) {
		sfxVolume = -1;
		return;
	}
	sfxVolume = newValue;
}

- (int)sfxVolume {
	if( sfxVolume < 0 || sfxVolume > 255 )
		return 192;
	return sfxVolume;
}

/** (assign) int speechVolume */
- (void) setSpeechVolume:(int)newValue {
	if( newValue < 0 || newValue > 255 ) {
		speechVolume = -1;
		return;
	}
	speechVolume = newValue;
}

- (int)speechVolume {
	if( speechVolume < 0 || speechVolume > 255 )
		return 192;
	return speechVolume;
}

/** (assign) BOOL iconChanged */

/** (retain) NSImage *gameIcon */

/** (copy) NSString *gameIconPath */

/*******************************************************************************************************************/
@end
