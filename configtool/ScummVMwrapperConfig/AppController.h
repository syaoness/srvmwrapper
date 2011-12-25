/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             AppController.h                                                                               *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>
#import "SVWDropImageView.h"
#import "SVWSettings.h"

@interface AppController : NSObject {
	IBOutlet SVWSettings *settings;
	
	IBOutlet NSMatrix *savePathRadio;
	IBOutlet SVWDropImageView *gameIconWell;
}

- (void)loadData;
- (void)saveData;
- (void)setGUI;

- (IBAction)revertToSaved: (id)sender;
- (IBAction)save: (id)sender;

- (IBAction)runGame: (id)sender;

@end
