//
//  AppController.m
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (id) init {
	self = [super init];

	gameName = nil;
	gameID = nil;
	saveIntoHome = YES;
	fullScreenMode = NO;
	aspectRatioCorrection = NO;
	gfxMode = nil;
	enableSubtitles = YES;
	language = nil;
	musicVolume = 0;
	sfxVolume = 0;
	speechVolume = 0;
	iconChanged = NO;
	gameIcon = nil;
	
	[self loadData];
	
	return self;
}

- (void) dealloc {
	[self saveData];

	[gameName release];
	[gameID release];
	[gfxMode release];
	[language release];
	[gameIcon release];

	[super dealloc];
}

- (void) awakeFromNib {
	[self setGUI];
	[NSApp setDelegate:self];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
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
	[NSApp terminate:self];
}

- (BOOL)windowShouldClose:(id)sender {
	if( ![[NSApp mainWindow] isDocumentEdited] )
		return YES;
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"Save"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Don't Save"];
	[alert setMessageText:@"Do you want to save the changes you made?"];
	[alert setInformativeText:@"Your changes will be lost if you don't save them."];
	[alert setAlertStyle:NSWarningAlertStyle];
	int returnCode = [alert runModal];
	if( returnCode == NSAlertSecondButtonReturn ) {
		return NO;
	} else {
		if( returnCode == NSAlertFirstButtonReturn )
			[self saveData];
		[[NSApp mainWindow] setDocumentEdited:NO];
		return YES;
	}
}

- (void) saveAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
	if( returnCode == NSAlertSecondButtonReturn ) {
		[NSApp replyToApplicationShouldTerminate: NO];
	} else {
		if( returnCode == NSAlertFirstButtonReturn )
			[self saveData];
		[NSApp replyToApplicationShouldTerminate: YES];
	}
}

- (void) loadData {
	NSBundle *mainBundle;
	NSDictionary *prefs;
	NSFileManager *filemanager;
	
	mainBundle = [NSBundle mainBundle];
	prefs = [NSDictionary dictionaryWithContentsOfFile:
			[NSString stringWithFormat:@"%@/../Contents/Info.plist", [mainBundle bundlePath]]];
	filemanager = [NSFileManager defaultManager];
	
	[gameName autorelease];
	[gameID autorelease];
	fullScreenMode = NO;
	aspectRatioCorrection = NO;
	[gfxMode autorelease];
	enableSubtitles = YES;
	[language autorelease];
	musicVolume = -1;
	sfxVolume = -1;
	speechVolume = -1;
	[gameIcon autorelease];
	if( prefs ) {
		NSString *strTemp;
		NSNumber *numTemp;

		if( (strTemp=[prefs objectForKey:@"CFBundleDisplayName"]) )
			gameName = [[NSString alloc] initWithString:strTemp];
		if( (strTemp=[prefs objectForKey:@"CFBundleName"]) )
			gameID = [[NSString alloc] initWithString:strTemp];
		if( (numTemp=[prefs valueForKey:@"SVWFullScreen"]) )
			fullScreenMode = [numTemp boolValue];
		if( (numTemp=[prefs valueForKey:@"SVWAspectRatio"]) )
			aspectRatioCorrection = [numTemp boolValue];
		if( (strTemp=[prefs objectForKey:@"SVWGFXMode"]) )
			gfxMode = [[NSString alloc] initWithString:strTemp];
		if( (numTemp=[prefs valueForKey:@"SVWEnableSubtitles"]) )
			enableSubtitles = [numTemp boolValue];
		if( (strTemp=[prefs objectForKey:@"SVWLanguage"]) )
			language = [[NSString alloc] initWithString:strTemp];
		if( (numTemp=[prefs valueForKey:@"SVWMusicVolume"]) )
			musicVolume = [numTemp intValue];
		if( (numTemp=[prefs valueForKey:@"SVWSFXVolume"]) )
			sfxVolume = [numTemp intValue];
		if( (numTemp=[prefs valueForKey:@"SVWSpeechVolume"]) )
			speechVolume = [numTemp intValue];
	}
	if( !gfxMode )
		gfxMode = [[NSString alloc] initWithString:@"2x"];
	if( !language )
		language = [[NSString alloc] initWithString:@"en"];
	if( musicVolume < 0 )
		musicVolume = 192;
	if( sfxVolume < 0 )
		sfxVolume = 192;
	if( speechVolume < 0 )
		speechVolume = 192;
	
	saveIntoHome = ![filemanager fileExistsAtPath:
			[NSString stringWithFormat:@"%@/../Contents/Resources/saves/.dontdeletethis",
			[mainBundle bundlePath]]];
	gameIcon = [[NSImage alloc] initWithContentsOfFile:
			[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns", [mainBundle bundlePath]]];
	
	iconChanged = NO;
	[[NSApp mainWindow] setDocumentEdited:NO];
}

- (void) saveData {
	if( ![[NSApp mainWindow] isDocumentEdited] )
		return;
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
	[prefs setObject:(language ? language : @"") forKey:@"SVWLanguage"];
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
	
	if( iconChanged && [gameIconWell filePath] ) {
		[filemanager removeItemAtPath:[NSString stringWithFormat:@"%@/../Contents/Resources/old.icns",
				[mainBundle bundlePath]] error:nil];
		[filemanager moveItemAtPath:[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns",
				[mainBundle bundlePath]] toPath:
				[NSString stringWithFormat:@"%@/../Contents/Resources/old.icns",
				[mainBundle bundlePath]] error:nil];
		[filemanager copyItemAtPath:[gameIconWell filePath]
				toPath:[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns",
				[mainBundle bundlePath]] error:nil];
	}
	[[NSApp mainWindow] setDocumentEdited:NO];
}

- (void) setGUI {
	[gameNameLine setStringValue:(gameName ? gameName : @"")];
	[gameIDLine setStringValue:(gameID ? gameID : @"")];
	[savePathRadio selectCellWithTag:(saveIntoHome ? 1 : 0)];
	[fullScreenModeCheck setState:(fullScreenMode ? NSOnState : NSOffState)];
	[aspectRatioCheck setState:(aspectRatioCorrection ? NSOnState : NSOffState)];
	[gfxModeLine setStringValue:(gfxMode ? gfxMode : @"")];
	[enableSubtitlesCheck setState:(enableSubtitles ? NSOnState : NSOffState)];
	[languageLine setStringValue:(language ? language : @"")];
	[musicVolumeSlider setIntValue:musicVolume];
	[sfxVolumeSlider setIntValue:sfxVolume];
	[speechVolumeSlider setIntValue:speechVolume];
	if( gameIcon ) {
		[gameIconWell setImage:gameIcon];
		[gameIconWell setFilePath:[NSString stringWithFormat:@"%@/../Contents/Resources/game.icns",
				[[NSBundle mainBundle] bundlePath]]];
	}
}

- (IBAction)revertToSaved: (id)sender {
	[self loadData];
	[self setGUI];
}

- (IBAction)save: (id)sender {
	[self saveData];
	[self loadData];
	[self setGUI];
}

- (IBAction) editGameName: (id)sender {
	[gameName autorelease];
	gameName = [[NSString alloc] initWithString:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editGameID: (id)sender {
	[gameID autorelease];
	gameID = [[NSString alloc] initWithString:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSavePath: (id)sender {
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
	fullScreenMode = [sender state];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editAspectRatioCorrection: (id)sender {
	aspectRatioCorrection = [sender state];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editGFXMode: (id)sender {
	[gfxMode autorelease];
	gfxMode = [[NSString alloc] initWithString:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSubtitlesMode: (id)sender {
	enableSubtitles = [sender state];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editLanguage: (id)sender {
	[language autorelease];
	language = [[NSString alloc] initWithString:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editMusicVolume: (id)sender {
	musicVolume = [sender intValue];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSFXVolume: (id)sender {
	sfxVolume = [sender intValue];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSpeechVolume: (id)sender {
	speechVolume = [sender intValue];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (void) savePathAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
	if( returnCode == NSAlertFirstButtonReturn ) {
		saveIntoHome = ([[savePathRadio selectedCell] tag] == 1);
		[[NSApp mainWindow] setDocumentEdited:YES];
	} else
		[savePathRadio selectCellWithTag:(saveIntoHome ? 1 : 0)];
}

- (IBAction) editIcon: (id)sender {
	[[NSApp mainWindow] setDocumentEdited:YES];
	[gameIcon release];
	gameIcon = [[gameIconWell image] copy];
	if( gameIcon )
		iconChanged = YES;
}

@end
