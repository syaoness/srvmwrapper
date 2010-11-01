//
//  AppController.h
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVWDropImageView.h"


@interface AppController : NSObject {
	NSString *gameName;
	NSString *gameID;
	NSImage *gameIcon;
	BOOL saveIntoHome;
	BOOL fullScreenMode;
	BOOL enableSubtitles;
	BOOL iconChanged;
	
	IBOutlet NSTextField *gameNameLine;
	IBOutlet NSComboBox *gameIDLine;
	IBOutlet SVWDropImageView *gameIconWell;
	IBOutlet NSMatrix *savePathRadio;
	IBOutlet NSButton *fullScreenModeCheck;
	IBOutlet NSButton *enableSubtitlesCheck;
}

- (id) init;
- (void) dealloc;
- (void) awakeFromNib;

- (void) loadData;
- (void) saveData;

- (void) setGUI;

- (IBAction)revertToSaved: (id)sender;
- (IBAction)save: (id)sender;

- (IBAction) editGameName: (id)sender;
- (IBAction) editGameID: (id)sender;
- (IBAction) editFullScreenMode: (id)sender;
- (IBAction) editSubtitlesMode: (id)sender;
- (IBAction) editSavePath: (id)sender;
- (IBAction) editIcon: (id)sender;

@end
