/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             AppController.m                                                                               *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "AppController.h"

#pragma mark Implementation
@implementation AppController

#pragma mark Constants
NSString * const kEditedObserver   = @"EditedObserver";
NSString * const kSaveGameObserver = @"SaveGameObserver";

#pragma mark -
#pragma mark Init and Dealloc
- (id)init {
	self = [super init];
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)awakeFromNib {
	[NSApp setDelegate:self];
	[exclamationMarkImageView setImage:[[NSWorkspace sharedWorkspace]
					    iconForFileType:NSFileTypeForHFSTypeCode(kAlertCautionIcon)]];
	[self loadData];
	[settings addObserver:self forKeyPath:@"edited" options:0 context:kEditedObserver];
	[gameIconWell bind:@"filePath" toObject:settings withKeyPath:@"gameIconPath" options:nil];
	[settings addObserver:self forKeyPath:@"saveGameLocation" options:0 context:kSaveGameObserver];
}

#pragma mark Notifications
- (void)saveAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
#pragma unused (alert, contextInfo)
	if (returnCode == NSAlertSecondButtonReturn) {
		[NSApp replyToApplicationShouldTerminate: NO];
		return;
	} else if (returnCode == NSAlertFirstButtonReturn) {
		[self saveData];
	}
	[NSApp replyToApplicationShouldTerminate: YES];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
#pragma unused (sender)
	if (![[NSApp mainWindow] isDocumentEdited])
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
	if (![[NSApp mainWindow] isDocumentEdited])
		return YES;
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"Save"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Don't Save"];
	[alert setMessageText:@"Do you want to save the changes you made?"];
	[alert setInformativeText:@"Your changes will be lost if you don't save them."];
	[alert setAlertStyle:NSWarningAlertStyle];
	NSInteger returnCode = [alert runModal];
	if (returnCode == NSAlertSecondButtonReturn) {
		return NO;
	} else {
		if (returnCode == NSAlertFirstButtonReturn)
			[self saveData];
		[[NSApp mainWindow] setDocumentEdited:NO];
		return YES;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
		       context:(void *)context {
	if (context == kEditedObserver) {
		[[NSApp mainWindow] setDocumentEdited:[settings isEdited]];
	} else if (context == kSaveGameObserver) {
		if ([settings saveGameLocation] != [settings saveGameLocationOriginal])
			[settings setSaveGameLocationEdited:YES];
		else
			[settings setSaveGameLocationEdited:NO];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark Load and Save
- (void)loadData {
	[settings loadData];
}

- (void)saveData {
	if (![[NSApp mainWindow] isDocumentEdited])
		return;
	[settings saveData];
}

- (IBAction)revertToSaved: (id)sender {
#pragma unused (sender)
	[self loadData];
}

- (IBAction)save: (id)sender {
#pragma unused (sender)
	[self saveData];
	[self loadData];
}

#pragma mark GUI actions
- (IBAction)runGame: (id)sender {
#pragma unused (sender)
	NSLog(@"%@", [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
		      stringByAppendingPathComponent:@"Contents/MacOS/scumm_w"]);
	[NSTask launchedTaskWithLaunchPath:[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
					    stringByAppendingPathComponent:@"Contents/MacOS/scumm_w"]
				 arguments:[NSArray array]];
}

#pragma mark NSComboBoxDataSource
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	if (aComboBox == gameIDComboBox) {
		NSLog(@"gameID (%ld)", index);
		return [[settings allGameIDs] objectAtIndex:index];
	} else if (aComboBox == gameLanguageComboBox) {
		NSLog(@"gameLang (%ld)", index);
		return [[settings allGameLanguages] objectAtIndex:index];
	} else if (aComboBox == gfxModeComboBox) {
		NSLog(@"GFX (%ld)", index);
		return [[settings allGFXModes] objectAtIndex:index];
	}
	NSLog(@"WTF (%ld)", index);
	return nil;
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	if (aComboBox == gameIDComboBox) {
		return [[settings allGameIDs] count];
	} else if (aComboBox == gameLanguageComboBox) {
		return [[settings allGameLanguages] count];
	} else if (aComboBox == gfxModeComboBox) {
		return [[settings allGFXModes] count];
	}
	return 0;
}

@end
