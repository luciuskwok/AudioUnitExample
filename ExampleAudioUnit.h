//
//  ExampleAudioUnit.h
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>


@interface ExampleAudioUnit : NSObject {
	AudioUnit audioUnit;
}

- (id)initWithAudioUnit:(AudioUnit)anAudioUnit;
- (NSView *)cocoaViewWithSize:(NSSize)viewSize;

@end
