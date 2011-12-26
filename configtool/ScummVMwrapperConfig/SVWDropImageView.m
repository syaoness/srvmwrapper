/*******************************************************************************************************************
 *                                     ScummVMwrapper :: SVWconfig                                                 *
 *******************************************************************************************************************
 * File:             SVWDropImageView.m                                                                            *
 * Copyright:        (c) 2010-2011 dotalux.com; syao                                                               *
 *******************************************************************************************************************/

#import "SVWDropImageView.h"

#pragma mark Implementation
@implementation SVWDropImageView

#pragma mark Properties
- (NSString *)filePath {
	return filePath;
}

- (void)setFilePath:(NSString *)aFilePath {
	if (aFilePath != filePath) {
		if (filePath != nil)
			[filePath release];
		if (aFilePath == nil) {
			filePath = nil;
			[self setImage:nil];
		} else {
			filePath = [aFilePath retain];
			[self setImage:[[[NSImage alloc] initWithContentsOfFile:filePath] autorelease]];
			if ([self image] == nil) {
				[filePath release];
				filePath = nil;
			}
		}
	}
}

#pragma mark Object creation, initialization, destruction
- (id)init {
	self = [super init];
	if (self) {
		filePath = [[NSString alloc] initWithString:@""];
	}
	return self;
}

- (void)dealloc {
//	[self unregisterDraggedTypes];
	[filePath release];
	[super dealloc];
}

#pragma mark NSDraggingDestination Protocol
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSPasteboard *pboard = [sender draggingPasteboard];
	
	NSArray *types = [NSArray arrayWithObject:NSFilenamesPboardType];
	
	NSString *desiredType = [pboard availableTypeFromArray:types];
	
	NSData *carriedData = [pboard dataForType:desiredType];
	
	if (carriedData == nil)
		return NO;
	
	if (![desiredType isEqualToString:NSFilenamesPboardType])
		return NO;
	
	NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];

	if ([files count] <= 0)
		return NO;
	
	NSString *path = [files objectAtIndex:0];

	NSString *appName = nil;
	NSString *fileType = nil;
	if (![[NSWorkspace sharedWorkspace] getInfoForFile:path application:&appName type:&fileType])
		return NO;
	if (![fileType isEqualToString:@"icns"])
		return NO;

	[self setFilePath:path];
	
	if ([self filePath] == nil)
		return NO;
	
	return [super performDragOperation:sender];
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
#pragma unused (sender)
	[self setNeedsDisplay:YES];
}

- (NSUInteger)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
#pragma unused (isLocal)
	return NSDragOperationCopy;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric)
		return NSDragOperationCopy;
	return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
#pragma unused (sender)
	// Invoked when the image is released, allowing the receiver to agree to or refuse drag operation.
	// TODO: User confirmation?
	return YES;
}

@end
