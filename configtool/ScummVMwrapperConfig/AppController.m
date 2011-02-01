//
//  AppController.m
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import "AppController.h"


@implementation AppController

#pragma mark Init and Dealloc
- (id) init {
	self = [super init];
	listGameIDs = [[NSArray alloc] initWithObjects:
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
			@"touche",		// Touche: The Adventures of the Fifth Musketeer
			@"tucker",		// Bud Tucker in Double Trouble
			@"water",		// Freddi Fish and Luther's Water Worries
			@"waxworks",		// Waxworks
			@"zak",			// Zak McKracken and the Alien Mindbenders
			nil];
	listGFXModes = [[NSArray alloc] initWithObjects:
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
	listLanguages = [[NSArray alloc] initWithObjects:
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
		settings = [[SVWSettings alloc] init];
		[self loadData];
	}
	return self;
}

- (void) dealloc {
	[self saveData];
	[settings release];

	[super dealloc];
}

- (void) awakeFromNib {
	[gameIDLine addItemsWithObjectValues:listGameIDs];
	[gfxModeLine addItemsWithObjectValues:listGFXModes];
	[languageLine addItemsWithObjectValues:listLanguages];
	[self setGUI];
	[NSApp setDelegate:self];
}

#pragma mark Events
- (void) savePathAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
#pragma unused (alert, contextInfo)
	if( returnCode == NSAlertFirstButtonReturn ) {
		[settings setSaveIntoHome:([[savePathRadio selectedCell] tag] == 1)];
		[[NSApp mainWindow] setDocumentEdited:YES];
	} else
		[savePathRadio selectCellWithTag:([settings saveIntoHome] ? 1 : 0)];
}

- (void) saveAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
#pragma unused (alert, contextInfo)
	if( returnCode == NSAlertSecondButtonReturn ) {
		[NSApp replyToApplicationShouldTerminate: NO];
	} else {
		if( returnCode == NSAlertFirstButtonReturn )
			[self saveData];
		[NSApp replyToApplicationShouldTerminate: YES];
	}
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
#pragma unused (sender)
	if( ![[NSApp mainWindow] isDocumentEdited] )
		return NSTerminateNow;
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"Save"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Don't Save"];
	[alert setMessageText:@"Do you want to save the changes you made?"];
	[alert setInformativeText:@"Your changes will be lost if you don't save them."];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self
			didEndSelector:@selector(saveAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
	return NSTerminateLater;
}

/*- (void)applicationWillTerminate:(NSNotification *)aNotification {
}*/

- (void)windowWillClose:(NSNotification *)aNotification {
#pragma unused (aNotification)
	[NSApp terminate:self];
}

- (BOOL)windowShouldClose:(id)sender {
#pragma unused (sender)
	if( ![[NSApp mainWindow] isDocumentEdited] )
		return YES;
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"Save"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Don't Save"];
	[alert setMessageText:@"Do you want to save the changes you made?"];
	[alert setInformativeText:@"Your changes will be lost if you don't save them."];
	[alert setAlertStyle:NSWarningAlertStyle];
	NSInteger returnCode = [alert runModal];
	if( returnCode == NSAlertSecondButtonReturn ) {
		return NO;
	} else {
		if( returnCode == NSAlertFirstButtonReturn )
			[self saveData];
		[[NSApp mainWindow] setDocumentEdited:NO];
		return YES;
	}
}

#pragma mark Load and Save
// TODO: Why do we have duplicated code, again >.<
- (void)loadData {
	[settings loadData];
	[[NSApp mainWindow] setDocumentEdited:NO];
}

- (void)saveData {
	if( ![[NSApp mainWindow] isDocumentEdited] )
		return;
	[settings saveData];
	[[NSApp mainWindow] setDocumentEdited:NO];
}

- (IBAction)revertToSaved: (id)sender {
#pragma unused (sender)
	[self loadData];
	[self setGUI];
}

- (IBAction)save: (id)sender {
#pragma unused (sender)
	[self saveData];
	[self loadData];
	[self setGUI];
}

#pragma mark GUI
- (void) setGUI {
	[gameNameLine setStringValue:([settings gameName] ? [settings gameName] : @"")];
	[gameIDLine setStringValue:([settings gameID] ? [settings gameID] : @"")];
	[savePathRadio selectCellWithTag:([settings saveIntoHome] ? 1 : 0)];
	[fullScreenModeCheck setState:([settings fullScreenMode] ? NSOnState : NSOffState)];
	[aspectRatioCheck setState:([settings aspectRatioCorrection] ? NSOnState : NSOffState)];
	[gfxModeLine setStringValue:([settings gfxMode] ? [settings gfxMode] : @"")];
	[enableSubtitlesCheck setState:([settings enableSubtitles] ? NSOnState : NSOffState)];
	[languageLine setStringValue:([settings gameLanguage] ? [settings gameLanguage] : @"")];
	[musicVolumeSlider setIntValue:[settings musicVolume]];
	[sfxVolumeSlider setIntValue:[settings sfxVolume]];
	[speechVolumeSlider setIntValue:[settings speechVolume]];
	if( [settings gameIcon] ) {
		[gameIconWell setImage:[settings gameIcon]];
		[gameIconWell setFilePath:[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns",
				[[NSBundle mainBundle] bundlePath]]];
	}
}

- (IBAction) editGameName: (id)sender {
	[settings setGameName:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editGameID: (id)sender {
	[settings setGameID:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSavePath: (id)sender {
#pragma unused (sender)
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText:@"Edit the Save Game Path settings?"];
	[alert setInformativeText:@"All the Save Games will be lost.  Make sure you have a backup."];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self
			didEndSelector:@selector(savePathAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction) editFullScreenMode: (id)sender {
	[settings setFullScreenMode:[sender state]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editAspectRatioCorrection: (id)sender {
	[settings setAspectRatioCorrection:[sender state]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editGFXMode: (id)sender {
	[settings setGfxMode:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSubtitlesMode: (id)sender {
	[settings setEnableSubtitles:[sender state]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editLanguage: (id)sender {
	[settings setGameLanguage:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editMusicVolume: (id)sender {
	[settings setMusicVolume:[sender intValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSFXVolume: (id)sender {
	[settings setSfxVolume:[sender intValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSpeechVolume: (id)sender {
	[settings setSpeechVolume:[sender intValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editIcon: (id)sender {
#pragma unused (sender)
	[settings setGameIcon:[gameIconWell image]];
	if( [settings gameIcon] ) {
		[settings setGameIconPath:[gameIconWell filePath]];
		[settings setIconChanged:YES];
	}
	[[NSApp mainWindow] setDocumentEdited:YES];
}

@end
