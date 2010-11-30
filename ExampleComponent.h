//
//  ExampleComponent.h
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>


@interface ExampleComponent : NSObject {
	Component component;
}

+ (NSArray *)availableComponentsOfType:(OSType)componentType;

- (id)initWithComponent:(Component)aComponent;
- (NSString *)name;
- (ComponentDescription)componentDescription;

@end
