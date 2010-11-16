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
	BOOL saveIntoHome;
	BOOL fullScreenMode;
	BOOL aspectRatioCorrection;
	NSString *gfxMode;
	BOOL enableSubtitles;
	NSString *language;
	NSNumber *musicVolume;
	NSNumber *sfxVolume;
	NSNumber *speechVolume;
	BOOL iconChanged;
	NSImage *gameIcon;
	
	IBOutlet NSTextField *gameNameLine;
	IBOutlet NSComboBox *gameIDLine;
	IBOutlet NSMatrix *savePathRadio;
	IBOutlet NSButton *fullScreenModeCheck;
	IBOutlet NSButton *aspectRatioCheck;
	IBOutlet NSComboBox *gfxModeLine;
	IBOutlet NSButton *enableSubtitlesCheck;
	IBOutlet NSComboBox *languageLine;
	IBOutlet NSSlider *musicVolumeSlider;
	IBOutlet NSSlider *sfxVolumeSlider;
	IBOutlet NSSlider *speechVolumeSlider;
	IBOutlet SVWDropImageView *gameIconWell;
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
- (IBAction) editSavePath: (id)sender;
- (IBAction) editFullScreenMode: (id)sender;
- (IBAction) editAspectRatioCorrection: (id)sender;
- (IBAction) editGFXMode: (id)sender;
- (IBAction) editSubtitlesMode: (id)sender;
- (IBAction) editLanguage: (id)sender;
- (IBAction) editMusicVolume: (id)sender;
- (IBAction) editSFXVolume: (id)sender;
- (IBAction) editSpeechVolume: (id)sender;
- (IBAction) editIcon: (id)sender;

@end
