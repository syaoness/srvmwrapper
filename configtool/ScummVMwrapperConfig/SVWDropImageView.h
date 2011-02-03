/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWDropImageView.h                                                                            *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************
 * $Id::                                                                     $: SVN Info                           *
 * $Date::                                                                   $: Last modification                  *
 * $Author::                                                                 $: Last modification author           *
 * $Revision::                                                               $: SVN Revision                       *
 *******************************************************************************************************************/

#import <Cocoa/Cocoa.h>


@interface SVWDropImageView : NSImageView {
//	NSImage *myImage;
	NSString *filePath;
}

//- (void)concludeDragOperation:(id<NSDraggingInfo>)sender;
- (NSUInteger)draggingSourceOperationMaskForLocal:(BOOL)isLocal;
- (void)mouseDown:(NSEvent *)theEvent;

@property (copy) NSString *filePath;

@end
