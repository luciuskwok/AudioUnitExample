//
//  ExampleAUGraph.m
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import "ExampleAUGraph.h"


@implementation ExampleAUGraph

- (id)init {
	self = [super init];
	if (self) {
		OSStatus err;
		
		// Create a new AUGraph.
		err = NewAUGraph (&auGraph);
		NSAssert1 (err == noErr, @"NewAUGraph() error %d", err);
		
		// Always keep the graph open
		err = AUGraphOpen (auGraph);
		NSAssert1 (err == noErr, @"AUGraphOpen() error %d", err);
		
		// Always initialized.
		[self initialize];
	}
	return self;
}

- (void)dealloc {
	DisposeAUGraph(auGraph);
	[super dealloc];
}

- (AUNode)addNodeWithComponentType:(OSType)componentType subType:(OSType)subType manufacturer:(OSType)manufacturer
{
	AUNode aNode = 0;
	AudioComponentDescription desc;
	desc.componentType = componentType;
	desc.componentSubType = subType;
	desc.componentManufacturer = manufacturer;
	desc.componentFlags = 0;
	desc.componentFlagsMask = 0;
	OSStatus err = AUGraphAddNode (auGraph, &desc, &aNode);
	NSAssert1 (err == noErr, @"AUGraphAddNode() error %d", err);
	return aNode;
}

- (AUNode)addNodeWithComponentDescription:(AudioComponentDescription)desc {
	AUNode aNode = 0;
	OSStatus err = AUGraphAddNode (auGraph, &desc, &aNode);
	NSAssert1 (err == noErr, @"AUGraphAddNode() error %d", err);
	return aNode;
}

- (void)removeNode:(AUNode)aNode {
	if (aNode == 0) return;
	
	OSStatus err = AUGraphRemoveNode (auGraph, aNode);
	NSAssert1 (err == noErr, @"AUGraphRemoveNode() error %d", err);
}

- (AudioUnit)audioUnitForNode:(AUNode)aNode {
	AudioUnit unit;
	OSStatus err = AUGraphNodeInfo(auGraph, aNode, NULL, &unit);
	NSAssert1 (err == noErr, @"AUGraphNodeInfo() error %d", err);
	return unit;
}

- (void)update {
	OSStatus err = AUGraphUpdate(auGraph, NULL);
	NSAssert1 (err == noErr, @"AUGraphUpdate() error %d", err);
}

- (BOOL)isInitialized {
	Boolean result = NO;
	OSStatus err = AUGraphIsInitialized(auGraph, &result);
	NSAssert1 (err == noErr, @"AUGraphIsInitialized() error %d", err);
	return (result != 0);
}

- (void)initialize {
	OSStatus err = AUGraphInitialize(auGraph);
	NSAssert1 (err == noErr, @"AUGraphInitialize() error %d", err);
}

- (void)uninitialize {
	OSStatus err = AUGraphUninitialize(auGraph);
	NSAssert1 (err == noErr, @"AUGraphUninitialize() error %d", err);
}


@end
