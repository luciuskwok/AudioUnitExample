//
//  AudioUnitExampleAppDelegate.h
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import "ExampleAudioUnit.h"
#import "ExampleAUGraph.h"
#import "ExampleComponent.h"


@interface AudioUnitExampleAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSView *audioUnitContainerView;
	NSPopUpButton *effectsPopUp;
	NSPopUpButton *presetsPopUp;
	
	NSArray *effects;

	ExampleAUGraph *auGraph;
	AUNode outputNode;
	AUNode effectsNode;
	
	NSView *audioUnitView;
	
	BOOL inLiveResize;
	BOOL listenToAudioUnitFrameSizeChanges;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *audioUnitContainerView;
@property (assign) IBOutlet NSPopUpButton *effectsPopUp;
@property (assign) IBOutlet NSPopUpButton *presetsPopUp;


- (IBAction)selectEffect:(id)sender;
- (IBAction)selectPreset:(id)sender;

@end
