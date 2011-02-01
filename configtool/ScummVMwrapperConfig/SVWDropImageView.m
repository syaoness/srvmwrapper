//
//  SVWDropImageView.m
//  ScummVMwrapperConfig
//
//  Created by Syaoran on 2010-10-13.
//  Copyright 2010 dotalux.com. All rights reserved.
//

#import "SVWDropImageView.h"


@implementation SVWDropImageView

#pragma mark Properties
@synthesize filePath;

#pragma mark Object creation, initialization, destruction
- (id)init {
	filePath = nil;
	return [super init];
}

- (void)dealloc {
//	[self unregisterDraggedTypes];
	[filePath release];
	filePath = nil;
	[super dealloc];
}

#pragma mark Events
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *files = nil;
	NSString *thePath = nil;
	
	//a list of types that we can accept
//	NSString *desiredType = [paste availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]];
//	NSData *carriedData = [paste dataForType:desiredType];
	
	if( ![pboard availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]] )
		return NO;
	
	files = [pboard propertyListForType:NSFilenamesPboardType];
	if( [files count] <= 0 )
		return NO;

	thePath = [files objectAtIndex:0];
	NSString *appName = nil;
	NSString *fileType = nil;

	if( ![[NSWorkspace sharedWorkspace] getInfoForFile:[NSURL fileURLWithPath: thePath] application:&appName
			type:&fileType] )
		return NO;
	if( ![fileType isEqualToString:@"icns"] )
		return NO;

	[self setFilePath:thePath];
	return [super performDragOperation:sender];
	
/*
	if( carriedData == nil ) {
 		// the operation failed for some reason
//		NSRunAlertPanel(@"Paste Error", @"Sorry, but the paste operation failed", nil, nil, nil);
		return NO;
	} else {
		// the pasteboard was able to give us some meaningful data
		if( [desiredType isEqualToString:NSTIFFPboardType] ) {
			// we have TIFF bitmap data in the NSData object
			NSImage *newImage = [[NSImage alloc] initWithData:carriedData];
			[self setImage:newImage];
			[newImage release];
			// we are no longer interested in this so we need to release it
		} else if( [desiredType isEqualToString:NSFilenamesPboardType] ) {
			// we have a list of file names in an NSData object
			NSArray *fileArray = [paste propertyListForType:@"NSFilenamesPboardType"];
			// be caseful since this method returns id.
			// We just happen to know that it will be an array.
			NSString *path = [fileArray objectAtIndex:0];
			// assume that we can ignore all but the first path in the list
			NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:path];
			
			if( newImage == nil ) {
				// we failed for some reason
//				NSRunAlertPanel(@"File Reading Error",
//						[NSString stringWithFormat:@"Sorry, but I failed to open the file at \"%@\"", path],
//						nil, nil, nil);
				return NO;
			} else {
				// newImage is now a new valid image
				[self setImage:newImage];
			}
			[newImage release];
		} else {
			// this can't happen
//			NSAssert(NO, @"This can't happen");
			return NO;
		}
	}
	[self setNeedsDisplay:YES];    //redraw us with the new image
	return YES;
*/

}

/*// at the end of a drag operation (of an image into this image view) we interrogate the dragging pasteboard
// and pull out the filename of the image being dragged
- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
	NSPasteboard *pboard;
	NSArray *files;
	
	pboard = [sender draggingPasteboard];
	[_filePath release];
	_filePath = nil;
	if( [pboard availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]] ) {
		files = [pboard propertyListForType:NSFilenamesPboardType];
		if ([files count] > 0)
			_filePath = [[files objectAtIndex:0] copy];
	}
	[super concludeDragOperation:sender];
}*/

- (NSUInteger)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
#pragma unused (isLocal)
	return NSDragOperationCopy;
}

- (void)mouseDown:(NSEvent *)theEvent {
	if( !filePath )
		return;
	NSImage *dragImage = nil;
	NSPoint dragPosition;
	NSArray *fileList = nil;
	NSPasteboard *pboard = nil;
	
	// write data to the pasteboard
	fileList = [NSArray arrayWithObjects:[self filePath], nil];
	pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	[pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:nil];
	[pboard setPropertyList:fileList forType:NSFilenamesPboardType];
	// start the drag operation
	dragImage = [[NSWorkspace sharedWorkspace] iconForFile:[self filePath]];
	dragPosition = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	dragPosition.x -= 16;
	dragPosition.y -= 16;
	[self dragImage:dragImage at:dragPosition offset:NSZeroSize event:theEvent pasteboard:pboard source:self slideBack:YES];
}

/*- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	if( (NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric ) {
		// this means that the sender is offering the type of operation we want
		// return that we want the NSDragOperationGeneric operation that they are offering
		return NSDragOperationGeneric;
	} else {
		// since they aren't offering the type of operation we want, we have
		// to tell them we aren't interested
		return NSDragOperationNone;
	}
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
	return YES;
}*/

@end
