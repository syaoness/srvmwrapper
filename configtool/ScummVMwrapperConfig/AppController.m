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

	[self loadData];
	
	return self;
}

- (void) dealloc {
	[self saveData];

	[gameName autorelease];
	[gameID autorelease];
	[gameIcon autorelease];

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
	
	if( prefs ) {
		NSString *strTemp;
		NSNumber *numTemp;

		if( (strTemp=[prefs objectForKey:@"CFBundleDisplayName"]) != nil )
			gameName = [[NSString alloc] initWithString:strTemp];
		else
			gameName = [[NSString alloc] init];

		if( (strTemp=[prefs objectForKey:@"CFBundleName"]) != nil )
			gameID = [[NSString alloc] initWithString:strTemp];
		else
			gameID = [[NSString alloc] init];

		fullScreenMode = ((numTemp=[prefs valueForKey:@"SVWFullScreen"]) != nil ? [numTemp boolValue] : NO);

		aspectRatioCorrection = ((numTemp=[prefs valueForKey:@"SVWAspectRatio"]) != nil ?
				[numTemp boolValue] : NO);

		gfxMode = [[NSString alloc] initWithString:((strTemp=[prefs objectForKey:@"SVWGFXMode"]) != nil ?
				strTemp : @"2x")];

		enableSubtitles = ((numTemp=[prefs valueForKey:@"SVWEnableSubtitles"]) != nil ?
				[numTemp boolValue] : YES);

		language = [[NSString alloc] initWithString:((strTemp=[prefs objectForKey:@"SVWLanguage"]) != nil ?
				strTemp : @"en")];

		musicVolume = [[NSNumber alloc] initWithInteger:
				((numTemp=[prefs valueForKey:@"SVWMusicVolume"]) != nil ? [numTemp intValue] : 192)];

		sfxVolume = [[NSNumber alloc] initWithInteger:
				((numTemp=[prefs valueForKey:@"SVWSFXVolume"]) != nil ? [numTemp intValue] : 192)];

		speechVolume = [[NSNumber alloc] initWithInteger:
				((numTemp=[prefs valueForKey:@"SVWSpeechVolume"]) != nil ? [numTemp intValue] : 192)];
	} else {
		gameName = [[NSString alloc] init];
		gameID = [[NSString alloc] init];
		fullScreenMode = NO;
		aspectRatioCorrection = NO;
		gfxMode = [[NSString alloc] initWithString:@"2x"];
		enableSubtitles = YES;
		language = [[NSString alloc] initWithString:@"en"];
		musicVolume = [[NSNumber alloc] initWithInteger:192];
		sfxVolume = [[NSNumber alloc] initWithInteger:192];
		speechVolume = [[NSNumber alloc] initWithInteger:192];
	}
	
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
	prefs = [NSMutableDictionary dictionaryWithCapacity:12];
	[prefs addEntriesFromDictionary: oldprefs];
	filemanager = [NSFileManager defaultManager];
	
	[prefs setObject:gameName forKey:@"CFBundleDisplayName"];
	[prefs setObject:gameID forKey:@"CFBundleName"];
	[prefs setObject:[NSString stringWithFormat:@"com.dotalux.scummwrapper.%@", gameID]
			forKey:@"CFBundleIdentifier"];
	[prefs setObject:[NSNumber numberWithBool:fullScreenMode] forKey:@"SVWFullScreen"];
	[prefs setObject:[NSNumber numberWithBool:aspectRatioCorrection] forKey:@"SVWAspectRatio"];
	[prefs setObject:gfxMode forKey:@"SVWGFXMode"];
	[prefs setObject:[NSNumber numberWithBool:enableSubtitles] forKey:@"SVWEnableSubtitles"];
	[prefs setObject:language forKey:@"SVWLanguage"];
	[prefs setObject:musicVolume forKey:@"SVWMusicVolume"];
	[prefs setObject:sfxVolume forKey:@"SVWSFXVolume"];
	[prefs setObject:speechVolume forKey:@"SVWSpeechVolume"];
	
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
	
	if( iconChanged && [gameIconWell filePath] != nil ) {
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
	[gameNameLine setStringValue:gameName];
	[gameIDLine setStringValue:gameID];
	[savePathRadio selectCellWithTag:(saveIntoHome ? 1 : 0)];
	[fullScreenModeCheck setState:[[NSNumber numberWithBool:fullScreenMode] integerValue]];
	[aspectRatioCheck setState:[[NSNumber numberWithBool:aspectRatioCorrection] integerValue]];
	[gfxModeLine setStringValue:gfxMode];
	[enableSubtitlesCheck setState:[[NSNumber numberWithBool:enableSubtitles] integerValue]];
	[languageLine setStringValue:language];
	[musicVolumeSlider setIntegerValue:[musicVolume integerValue]];
	[sfxVolumeSlider setIntegerValue:[sfxVolume integerValue]];
	[speechVolumeSlider setIntegerValue:[speechVolume integerValue]];
	if( gameIcon != nil ) {
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
	musicVolume = [[NSNumber alloc] initWithInteger:[sender intValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSFXVolume: (id)sender {
	sfxVolume = [[NSNumber alloc] initWithInteger:[sender intValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSpeechVolume: (id)sender {
	speechVolume = [[NSNumber alloc] initWithInteger:[sender intValue]];
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
	if( gameIcon != nil )
		[gameIcon autorelease];
	gameIcon = [[gameIconWell image] copy];
	if( gameIcon != nil )
		iconChanged = YES;
}

@end
