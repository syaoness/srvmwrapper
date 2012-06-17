/*******************************************************************************************************************
 *                                     ScummVMwrapper :: svwlauncher                                               *
 *******************************************************************************************************************
 * File:             SVWAppDelegate.h                                                                              *
 * Copyright:        (c) 2010-2012 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>

@interface SVWAppDelegate : NSObject <NSApplicationDelegate> {
    BOOL configRun;
    BOOL configToolFound;

    BOOL loaded;
    NSUInteger engineType;

    /// Common
    NSString *gameID;
    BOOL fullScreenMode;
    NSString *gameLanguage;
    NSString *extraArguments;
    BOOL subtitlesEnabled;
    NSUInteger musicVolume;
    NSUInteger sfxVolume;
    NSUInteger speechVolume;

    /// ScummVM
    BOOL aspectRatioCorrectionEnabled;
    NSString *gfxMode;

    /// ResidualVM
    BOOL sw3DRenderer;
    BOOL fpsCounterEnabled;
}

#pragma mark -
#pragma mark Properties
@property (assign, getter=isConfigRun) BOOL configRun;
@property (assign, getter=isConfigToolFound) BOOL configToolFound;

@property (assign, getter=isLoaded) BOOL loaded;
@property (assign) NSUInteger engineType;

#pragma mark Common
@property (retain) NSString *gameID;
@property (assign, getter=isFullScreenMode) BOOL fullScreenMode;
@property (retain) NSString *gameLanguage;
@property (retain) NSString *extraArguments;
@property (assign, getter=isSubtitlesEnabled) BOOL subtitlesEnabled;
@property (assign) NSUInteger musicVolume;
@property (assign) NSUInteger sfxVolume;
@property (assign) NSUInteger speechVolume;

#pragma mark ScummVM
@property (assign, getter=isAspectRatioCorrectionEnabled) BOOL aspectRatioCorrectionEnabled;
@property (retain) NSString *gfxMode;

#pragma mark ResidualVM
@property (assign, getter=isSw3DRenderer) BOOL sw3DRenderer;
@property (assign, getter=isFpsCounterEnabled) BOOL fpsCounterEnabled;


//- (NSString *)systemCommand:(NSString *)command; //run system command with output returned
#pragma mark Methods
- (BOOL)runConfig;
- (BOOL)loadData;
- (void)resetDefaultValues;
- (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
                           inDomain:(NSSearchPathDomainMask)domainMask appendPathComponent:(NSString *)appendComponent
                              error:(NSError **)errorOut;

@end
