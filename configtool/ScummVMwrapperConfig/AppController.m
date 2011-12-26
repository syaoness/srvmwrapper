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
	if (self) {
//		[self loadData];
	}
	return self;
}

- (void)dealloc {
	[self saveData];

	[super dealloc];
}

- (void)awakeFromNib {
	[NSApp setDelegate:self];
	[settings setEdited:NO];
	[exclamationMarkImageView setImage:[[NSWorkspace sharedWorkspace]
					    iconForFileType:NSFileTypeForHFSTypeCode(kAlertCautionIcon)]];
	[settings addObserver:self forKeyPath:@"edited" options:0 context:kEditedObserver];
	[gameIconWell bind:@"filePath" toObject:settings withKeyPath:@"gameIconPath" options:nil];
	[settings addObserver:self forKeyPath:@"saveGameLocation" options:0 context:kSaveGameObserver];
}

#pragma mark Notifications
- (void)saveAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(int*)contextInfo {
#pragma unused (alert, contextInfo)
	if (returnCode == NSAlertSecondButtonReturn) {
		[NSApp replyToApplicationShouldTerminate: NO];
	} else {
		if (returnCode == NSAlertFirstButtonReturn)
			[self saveData];
		[NSApp replyToApplicationShouldTerminate: YES];
	}
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
	[[NSApp mainWindow] setDocumentEdited:NO];
}

- (void)saveData {
	if (![[NSApp mainWindow] isDocumentEdited])
		return;
	[settings saveData];
	[[NSApp mainWindow] setDocumentEdited:NO];
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

@end
