//
//  SVWDropImageView.h
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SVWDropImageView : NSImageView {
//	NSImage *_myImage;
	NSString *_filePath;
}

- (void)setFilePath:(NSString *)path;
- (NSString *)filePath;
//- (void)concludeDragOperation:(id<NSDraggingInfo>)sender;
- (NSUInteger)draggingSourceOperationMaskForLocal:(BOOL)isLocal;
- (void)mouseDown:(NSEvent *)theEvent;

@end
