//
//  SVWDropImageView.h
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

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
