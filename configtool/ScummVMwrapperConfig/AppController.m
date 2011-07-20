/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             AppController.m                                                                               *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "AppController.h"

/*******************************************************************************************************************/
@implementation AppController

/*******************************************************************************************************************/
#pragma mark Init and Dealloc
- (id) init {
	self = [super init];
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
	[gameIDLine addItemsWithObjectValues:[settings allGameIDs]];
	[gfxModeLine addItemsWithObjectValues:[settings allGFXModes]];
	[languageLine addItemsWithObjectValues:[settings allGameLanguages]];
	[self setGUI];
	[NSApp setDelegate:self];
}

/*******************************************************************************************************************/
#pragma mark Events
- (void) savePathAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
#pragma unused (alert, contextInfo)
	if( returnCode == NSAlertFirstButtonReturn ) {
		[settings setSaveIntoHome:([[savePathRadio selectedCell] tag] == 1)];
		[[NSApp mainWindow] setDocumentEdited:YES];
	} else
		[savePathRadio selectCellWithTag:([settings isSaveIntoHome] ? 1 : 0)];
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

#if 0
- (void)applicationWillTerminate:(NSNotification *)aNotification {
}
#endif // 0

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

/*******************************************************************************************************************/
#pragma mark Load and Save
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

/*******************************************************************************************************************/
#pragma mark GUI
- (void) setGUI {
	[gameNameLine setStringValue:([settings gameName] ? [settings gameName] : @"")];
	[gameIDLine setStringValue:([settings gameID] ? [settings gameID] : @"")];
	[savePathRadio selectCellWithTag:([settings isSaveIntoHome] ? 1 : 0)];
	[fullScreenModeCheck setState:([settings isFullScreenMode] ? NSOnState : NSOffState)];
	[aspectRatioCheck setState:([settings isAspectRatioCorrectionEnabled] ? NSOnState : NSOffState)];
	[gfxModeLine setStringValue:([settings gfxMode] ? [settings gfxMode] : @"")];
	[enableSubtitlesCheck setState:([settings isSubtitlesEnabled] ? NSOnState : NSOffState)];
	[languageLine setStringValue:([settings gameLanguage] ? [settings gameLanguage] : @"")];
	[musicVolumeSlider setIntValue:[settings musicVolume]];
	[sfxVolumeSlider setIntValue:[settings sfxVolume]];
	[speechVolumeSlider setIntValue:[settings speechVolume]];
	if( [settings gameIcon] ) {
		[gameIconWell setImage:[settings gameIcon]];
		[gameIconWell setFilePath:[NSString stringWithFormat:@"%@/game.icns", [[NSBundle bundleWithPath:
				[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]] resourcePath]]];
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
	[settings setAspectRatioCorrectionEnabled:[sender state]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editGFXMode: (id)sender {
	[settings setGfxMode:[sender stringValue]];
	[[NSApp mainWindow] setDocumentEdited:YES];
}

- (IBAction) editSubtitlesMode: (id)sender {
	[settings setSubtitlesEnabled:[sender state]];
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

/*******************************************************************************************************************/
@end
