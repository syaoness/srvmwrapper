/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWDropImageView.h                                                                            *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>

#pragma mark Interface
@interface SVWDropImageView : NSImageView {
    NSString *filePath;
}

#pragma mark Methods
- (NSUInteger)draggingSourceOperationMaskForLocal:(BOOL)isLocal;

#pragma mark Properties
@property (retain) NSString *filePath;

@end
