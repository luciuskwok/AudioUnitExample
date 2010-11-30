//
//  AudioUnitExampleAppDelegate.m
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import "AudioUnitExampleAppDelegate.h"


@implementation AudioUnitExampleAppDelegate

@synthesize window, audioUnitContainerView, effectsPopUp, presetsPopUp;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	auGraph = [[ExampleAUGraph alloc] init];
	
	// Audio input/output node.
	outputNode = [auGraph addNodeWithComponentType:kAudioUnitType_Output subType:kAudioUnitSubType_DefaultOutput manufacturer:kAudioUnitManufacturer_Apple];
	
	// Load effects popup
	effects = [[ExampleComponent availableComponentsOfType:kAudioUnitType_Effect] retain];
	[effectsPopUp removeAllItems];
	for (ExampleComponent *effect in effects) {
		[effectsPopUp addItemWithTitle:[effect name]];
	}
	
	// Select effect.
	if (effects.count > 0) {
		[self selectEffect:effectsPopUp];
	}
	
	
}

- (IBAction)selectEffect:(id)sender {
	NSUInteger index = [sender indexOfSelectedItem];
	ExampleComponent *effect = [effects objectAtIndex:index];
	ComponentDescription desc = [effect componentDescription];
	
	// Notifications
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	if (audioUnitView != nil) 
		[center removeObserver:self name:NSViewFrameDidChangeNotification object:audioUnitView];
	
	// Uninitialize graph.
	if ([auGraph isInitialized])
		[auGraph uninitialize];
	
	// Remove old custom UI.
	[audioUnitView removeFromSuperview];
	
	// Replace any existing effects node with the new one.
	[auGraph removeNode:effectsNode];
	effectsNode = [auGraph addNodeWithComponentType:desc.componentType subType:desc.componentSubType manufacturer:desc.componentManufacturer];
	
	// Update graph for new node and initialize before showing AudioUnit UI.
	[auGraph update];
	[auGraph initialize];
	
	// Add new AudioUnit UI.
	ExampleAudioUnit *unit = [[[ExampleAudioUnit alloc] initWithAudioUnit:[auGraph audioUnitForNode:effectsNode]] autorelease];
	audioUnitView = [unit cocoaViewWithSize:audioUnitContainerView.bounds.size];
	[audioUnitContainerView addSubview:audioUnitView];

	// Add notification listener for view size change.
	listenToAudioUnitFrameSizeChanges = YES;
	[center addObserver:self selector:@selector(audioUnitViewFrameDidChange:) name:NSViewFrameDidChangeNotification object:audioUnitView];
	
	// TODO: Update Presets popup.
}

- (IBAction)selectPreset:(id)sender {
	NSLog (@"selectPreset: %@", sender);
}

#pragma mark Window

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
	// Turn off auto-resizing of window to size of Audio Unit view while manually resizing.
	inLiveResize = YES;
	return frameSize;
}

- (void)windowDidResize:(NSNotification *)notification {
	inLiveResize = NO;
}

- (void)resizeWindowForAudioUnitViewSize:(NSSize)aSize {
	NSRect windowFrame = [window frame];
	NSRect contentRect = [window contentRectForFrameRect:windowFrame];
	
	NSSize boxSize = audioUnitContainerView.frame.size;
	CGFloat widthOffset = contentRect.size.width - boxSize.width;
	CGFloat heightOffset = contentRect.size.height - boxSize.height;
	
	// Calculate new window size
	NSSize newSize;
	newSize.width  = aSize.width  + widthOffset;
	newSize.height = aSize.height + heightOffset;
	
	// Constrain to minimum size
	NSSize minWindowSize = [window contentMinSize];
	if (newSize.width < minWindowSize.width)
		newSize.width = minWindowSize.width;
	if (newSize.height < minWindowSize.height)
		newSize.height = minWindowSize.height;
	
	// Set new content frame size
	contentRect.origin.y += contentRect.size.height - newSize.height;
	contentRect.size.width = newSize.width;
	contentRect.size.height = newSize.height;
	
	// Resize the window
	windowFrame = [window frameRectForContentRect:contentRect];
	[window setFrame:windowFrame display:YES animate:NO];
	
	// Resize Audio Unit view to fit inside container view.
	NSSize containerSize = audioUnitContainerView.frame.size;
	[audioUnitView setFrame: NSMakeRect (0, 0, containerSize.width, containerSize.height)];
}

- (void)audioUnitViewFrameDidChange:(NSNotification *)notification {
	if (inLiveResize == YES) return;
	if (listenToAudioUnitFrameSizeChanges == NO) return;
	
	listenToAudioUnitFrameSizeChanges = NO;
	
	[self resizeWindowForAudioUnitViewSize:audioUnitView.frame.size];
	
	listenToAudioUnitFrameSizeChanges = YES;
}

@end
