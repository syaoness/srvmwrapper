/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWDropImageView.h                                                                            *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>


@interface SVWDropImageView : NSImageView {
	NSString *filePath;
}

- (NSUInteger)draggingSourceOperationMaskForLocal:(BOOL)isLocal;

@property (retain) NSString *filePath;

@end
