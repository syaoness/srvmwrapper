//
//  AppController.h
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVWDropImageView.h"
#import "SVWSettings.h"

@interface AppController : NSObject {
	SVWSettings *settings;
	NSArray *listGameIDs;
	NSArray *listGFXModes;
	NSArray *listLanguages;
	
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

- (void)loadData;
- (void)saveData;
- (void)setGUI;

- (IBAction)editGameName:(id)sender;
- (IBAction)editGameID:(id)sender;
- (IBAction)editSavePath:(id)sender;
- (IBAction)editFullScreenMode:(id)sender;
- (IBAction)editAspectRatioCorrection:(id)sender;
- (IBAction)editGFXMode:(id)sender;
- (IBAction)editSubtitlesMode:(id)sender;
- (IBAction)editLanguage:(id)sender;
- (IBAction)editMusicVolume:(id)sender;
- (IBAction)editSFXVolume:(id)sender;
- (IBAction)editSpeechVolume:(id)sender;
- (IBAction)editIcon:(id)sender;

- (IBAction)revertToSaved: (id)sender;
- (IBAction)save: (id)sender;

@end
