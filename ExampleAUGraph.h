//
//  ExampleAUGraph.h
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>


@interface ExampleAUGraph : NSObject {
	AUGraph auGraph;
}

- (AUNode)addNodeWithComponentType:(OSType)componentType subType:(OSType)subType manufacturer:(OSType)manufacturer;
- (AUNode)addNodeWithComponentDescription:(AudioComponentDescription)desc;
- (void)removeNode:(AUNode)aNode;
- (AudioUnit)audioUnitForNode:(AUNode)aNode;

- (void)update;

- (BOOL)isInitialized;
- (void)initialize;
- (void)uninitialize;

@end
