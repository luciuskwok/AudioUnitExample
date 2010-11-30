//
//  ExampleAudioUnit.m
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import "ExampleAudioUnit.h"
#import <CoreAudioKit/CoreAudioKit.h>
#import <AudioUnit/AUCocoaUIView.h>


@implementation ExampleAudioUnit

- (id)initWithAudioUnit:(AudioUnit)anAudioUnit {
	self = [super init];
	if (self) {
		audioUnit = anAudioUnit;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (NSData*)dataForProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element: (AudioUnitElement)element
{
	NSAssert(audioUnit != nil, @"audioUnit should not be nil");

	ComponentResult err;
	UInt32 dataSize;
	Boolean writable;
	
	err = AudioUnitGetPropertyInfo (audioUnit, property, scope, element, &dataSize, &writable);
	if (err != noErr)
		return nil;
	
	NSMutableData *data = [NSMutableData dataWithLength:dataSize];
	err = AudioUnitGetProperty (audioUnit, property, scope, element, [data mutableBytes], &dataSize);
	NSAssert1 (err == noErr, @"AudioUnitGetProperty() error: %d", err);

	[data setLength: dataSize];
	return data;
}

- (BOOL)plugInClassIsValid:(Class) pluginClass {
	if ([pluginClass conformsToProtocol:@protocol(AUCocoaUIBase)]) {
		if ([pluginClass instancesRespondToSelector:@selector(interfaceVersion)] &&
			[pluginClass instancesRespondToSelector:@selector(uiViewForAudioUnit:withSize:)]) {
			return YES;
		}
	}
	return NO;
}

- (NSView *)customCocoaUIWithViewSize:(NSSize)viewSize {	
	NSData *infoData = [self dataForProperty:kAudioUnitProperty_CocoaUI scope:kAudioUnitScope_Global element:0];
	if (infoData == nil)
		return nil;
	
	const AudioUnitCocoaViewInfo *info = [infoData bytes];

	NSURL *cocoaViewPath = (NSURL*)info->mCocoaAUViewBundleLocation;
	if (cocoaViewPath == nil) 
		return nil;
	
	NSString *factoryClassName = (NSString *)info->mCocoaAUViewClass[0];
	if (factoryClassName == nil) 
		return nil;
	
	NSBundle *viewBundle = [NSBundle bundleWithPath:[cocoaViewPath path]];
	NSAssert (viewBundle != nil, @"Error loading AU view's bundle");
	
	Class factoryClass = [viewBundle classNamed:factoryClassName];
	NSAssert (factoryClass != nil, @"Error getting AU view's factory class from bundle");
	
	// make sure 'factoryClass' implements the AUCocoaUIBase protocol
	NSAssert ([self plugInClassIsValid:factoryClass], @"AU view's factory class does not properly implement the AUCocoaUIBase protocol");
	
	// make a factory
	id factoryInstance = [[[factoryClass alloc] init] autorelease];
	NSAssert (factoryInstance != nil, @"Could not create an instance of the AU view factory");
	
	// make a view
	NSView *result = [factoryInstance uiViewForAudioUnit:audioUnit withSize:viewSize];
	
	// clean up
	[cocoaViewPath release];
	NSUInteger i;
	NSUInteger count = ([infoData length] - sizeof(CFURLRef)) / sizeof(CFStringRef);
	for (i = 0; i < count; i++)
		CFRelease(info->mCocoaAUViewClass[i]);

	return result;
}

- (NSView *)genericCocoaUI  {
	AUGenericView *view = nil;
	
	// Check that class is available if CoreAudioKit was weak-linked.
	if (objc_getClass ("AUGenericView") != nil) {
		view = [[[AUGenericView alloc] initWithAudioUnit: audioUnit] autorelease];
		[view setShowsExpertParameters:NO];
	}
	return view;
}

- (NSView *)cocoaViewWithSize:(NSSize)viewSize {
	NSView *customView = [self customCocoaUIWithViewSize:viewSize];
	if (customView == nil) {
		customView = [self genericCocoaUI];
	}
	NSAssert (customView != nil, @"Could not get a Cocoa UI view.");
	
	[customView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
	customView.frame = NSMakeRect(0, 0, viewSize.width, viewSize.height);
	return customView;
}

@end
