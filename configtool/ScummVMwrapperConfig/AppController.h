/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             AppController.h                                                                               *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>
#import "SVWDropImageView.h"
#import "SVWSettings.h"

#pragma mark Interface
@interface AppController : NSObject <NSComboBoxDataSource> {
	IBOutlet SVWSettings *settings;
	
	IBOutlet SVWDropImageView *gameIconWell;
	IBOutlet NSImageView *exclamationMarkImageView;
	
	IBOutlet NSComboBox *gameIDComboBox;
	IBOutlet NSComboBox *gfxModeComboBox;
	IBOutlet NSComboBox *gameLanguageComboBox;

	NSString *wrapperVersion;
	NSString *scummVMVersion;
	NSString *residualVersion;
}

#pragma mark Methods
- (void)loadData;
- (void)saveData;

- (NSString *)scummVMVersionFromExe;
- (NSString *)residualVersionFromExe;

#pragma mark IBActions
- (IBAction)revertToSaved: (id)sender;
- (IBAction)save: (id)sender;

- (IBAction)runGame: (id)sender;

#pragma mark Properties
@property (retain) NSString *wrapperVersion;
@property (retain) NSString *scummVMVersion;
@property (retain) NSString *residualVersion;

@end
