/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             AppController.h                                                                               *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>
#import "SVWDropImageView.h"
#import "SVWSettings.h"
#import "SVWWrapperUpdater.h"

#pragma mark Interface
@interface AppController : NSObject <NSComboBoxDataSource> {
    SVWWrapperUpdater *updateManager;

    IBOutlet SVWSettings *settings;
    
    IBOutlet SVWDropImageView *gameIconWell;
    IBOutlet NSImageView *exclamationMarkImageView;
    
    IBOutlet NSComboBox *gameIDComboBox;
    IBOutlet NSComboBox *gfxModeComboBox;
    IBOutlet NSComboBox *gameLanguageComboBox;
    
    NSString *configToolVersion;
    NSString *wrapperVersion;
    NSString *scummVMVersion;
    NSString *residualVersion;

    BOOL updateAvailable;
    BOOL insideWrapper;
}

#pragma mark Methods
- (BOOL)loadData;
- (void)saveData;

- (NSString *)scummVMVersionFromExe;
- (NSString *)residualVersionFromExe;

#pragma mark IBActions
- (IBAction)revertToSaved: (id)sender;
- (IBAction)save: (id)sender;

- (IBAction)runGame: (id)sender;
- (IBAction)upgradeWrapper:(id)sender;
- (IBAction)revealSaveInFinder:(id)sender;
- (IBAction)revealGameInFinder:(id)sender;

#pragma mark Properties
@property (retain) NSString *configToolVersion;
@property (retain) NSString *wrapperVersion;
@property (retain) NSString *scummVMVersion;
@property (retain) NSString *residualVersion;
@property (assign, getter=isUpdateAvailable) BOOL updateAvailable;
@property (assign, getter=isInsideWrapper) BOOL insideWrapper;

@end
