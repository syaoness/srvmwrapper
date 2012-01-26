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

NSString * const kScummVMExe       = @"scummvm";
NSString * const kResidualExe      = @"residual";
NSString * const kVersionArgument  = @"--version";

#pragma mark Properties
@synthesize configToolVersion;
@synthesize wrapperVersion;
@synthesize scummVMVersion;
@synthesize residualVersion;
@synthesize updateAvailable;
@synthesize insideWrapper;

#pragma mark -
#pragma mark Init and Dealloc
- (id)init {
	self = [super init];
	if (self) {
		configToolVersion = [[NSString alloc] initWithString:@""];
		wrapperVersion = [[NSString alloc] initWithString:@""];
		scummVMVersion = [[NSString alloc] initWithString:@""];
		residualVersion = [[NSString alloc] initWithString:@""];
		updateAvailable = NO;
		insideWrapper = NO;
		updateManager = [[SVWWrapperUpdater alloc] init];
	}
	return self;
}

- (void)dealloc {
	[updateManager release];
	[configToolVersion release];
	[wrapperVersion release];
	[scummVMVersion release];
	[residualVersion release];

	[super dealloc];
}

- (void)awakeFromNib {
	[NSApp setDelegate:self];
	[exclamationMarkImageView setImage:[[NSWorkspace sharedWorkspace]
					    iconForFileType:NSFileTypeForHFSTypeCode(kAlertCautionIcon)]];
	
	[self setConfigToolVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:kCFBundleShortVersionString]];
	NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
							    stringByDeletingLastPathComponent]];
	[self setWrapperVersion:[wrapperBundle objectForInfoDictionaryKey:kCFBundleShortVersionString]];
	
	[self setInsideWrapper:[self loadData]];

	[self setScummVMVersion:[self scummVMVersionFromExe]];
	[self setResidualVersion:[self residualVersionFromExe]];

	[settings addObserver:self forKeyPath:@"edited" options:0 context:kEditedObserver];
	[gameIconWell bind:@"filePath" toObject:settings withKeyPath:@"gameIconPath" options:nil];
	[settings addObserver:self forKeyPath:@"saveGameLocation" options:0 context:kSaveGameObserver];
	
	if ([self isInsideWrapper]) {
		[self setUpdateAvailable:[updateManager checkForUpdates]];
	} else {
		// TODO: Offer a way to just check for updates
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"Create"];
		[alert addButtonWithTitle:@"Cancel"];
		[alert setMessageText:@"Do you want to create a blank wrapper?"];
		[alert setInformativeText:@"You need to create a wrapper in order to use this tool."];
		[alert setAlertStyle:NSInformationalAlertStyle];
		if ([alert runModal] == NSAlertFirstButtonReturn) {
			NSSavePanel *destinationPicker = [NSSavePanel savePanel];
			[destinationPicker setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
			[destinationPicker setAllowsOtherFileTypes:NO];
			[destinationPicker setCanCreateDirectories:YES];
			[destinationPicker setMessage:@"Choose where to create the wrapper"];
			[destinationPicker setNameFieldLabel:@"Wrapper name:"];
			[destinationPicker setNameFieldStringValue:@"MyWrapper.app"]; // FIXME: 10.6 only
			[destinationPicker setPrompt:@"Create"];
			[destinationPicker setTitle:@"Create a new wrapper"];
			switch ([destinationPicker runModal]) {
			case NSFileHandlingPanelOKButton:
				[updateManager createBlankAtPath:[[destinationPicker URL] path]];
				// TODO: Successfully created
				break;
			case NSFileHandlingPanelCancelButton:
				break;
			}
		}
	}
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
	if (![self isInsideWrapper])
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
	if (![self isInsideWrapper])
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
- (BOOL)loadData {
	return [settings loadData];
}

- (void)saveData {
	if (![[NSApp mainWindow] isDocumentEdited])
		return;
	if (![self isInsideWrapper])
		return;
	[settings saveData];
}

- (NSString *)scummVMVersionFromExe {
	if (![self isInsideWrapper])
		return @"";
	NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
							    stringByDeletingLastPathComponent]];
	if (wrapperBundle == nil)
		return @"";
	NSString *executablePath = [wrapperBundle pathForAuxiliaryExecutable:kScummVMExe];
	if (executablePath == nil)
		return @"";
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:executablePath];
	[task setArguments:[NSArray arrayWithObjects:kVersionArgument, nil]];
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];
	NSFileHandle *file = [pipe fileHandleForReading];
	[task launch];
	NSData *data = [file readDataToEndOfFile];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[task autorelease];
	if (string == nil)
		return @"";
	string = [[string componentsSeparatedByString:@" "] objectAtIndex:1];
	if (string == nil)
		return @"";
	return string;
}

- (NSString *)residualVersionFromExe {
	if (![self isInsideWrapper])
		return @"";
	NSBundle *wrapperBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath]
							    stringByDeletingLastPathComponent]];
	if (wrapperBundle == nil)
		return @"";
	NSString *executablePath = [wrapperBundle pathForAuxiliaryExecutable:kResidualExe];
	if (executablePath == nil)
		return @"";
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:executablePath];
	[task setArguments:[NSArray arrayWithObjects:kVersionArgument, nil]];
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];
	NSFileHandle *file = [pipe fileHandleForReading];
	[task launch];
	NSData *data = [file readDataToEndOfFile];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[task autorelease];
	if (string == nil)
		return @"";
	string = [[string componentsSeparatedByString:@" "] objectAtIndex:1];
	if (string == nil)
		return @"";
	return string;
}

- (IBAction)revertToSaved: (id)sender {
#pragma unused (sender)
	[self loadData];
}

- (IBAction)save: (id)sender {
#pragma unused (sender)
	if (![self isInsideWrapper])
		return;
	[self saveData];
	[self loadData];
}

#pragma mark GUI actions
- (IBAction)runGame: (id)sender {
#pragma unused (sender)
	if (![self isInsideWrapper])
		return;
	NSLog(@"%@", [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
		      stringByAppendingPathComponent:@"Contents/MacOS/scumm_w"]);
	[NSTask launchedTaskWithLaunchPath:[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
					    stringByAppendingPathComponent:@"Contents/MacOS/scumm_w"]
				 arguments:[NSArray array]];
}

#pragma mark NSComboBoxDataSource
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	if (aComboBox == gameIDComboBox) {
		return [[settings allGameIDs] objectAtIndex:index];
	} else if (aComboBox == gameLanguageComboBox) {
		return [[settings allGameLanguages] objectAtIndex:index];
	} else if (aComboBox == gfxModeComboBox) {
		return [[settings allGFXModes] objectAtIndex:index];
	}
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
