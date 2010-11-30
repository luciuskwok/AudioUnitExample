//
//  ExampleComponent.m
//  AudioUnitExample
//
//  Created by Lucius Kwok on 11/28/10.
//  Copyright 2010 Felt Tip Inc. All rights reserved.
//

#import "ExampleComponent.h"


@implementation ExampleComponent

+ (NSArray *)availableComponentsOfType:(OSType)componentType {
	
	NSMutableArray *array = [NSMutableArray array];
	ComponentDescription found;
	ComponentDescription desc;
	memset(&desc, 0, sizeof(desc));
	desc.componentType = componentType;
	
	Component aComponent = FindNextComponent (NULL, &desc);
	while (aComponent != NULL) {
		GetComponentInfo (aComponent, &found, nil, nil, nil);
		
		ExampleComponent *exampleComponent = [[[ExampleComponent alloc] initWithComponent:aComponent] autorelease];
		[array addObject:exampleComponent];
		
		aComponent = FindNextComponent (aComponent, &desc);
	}
	return array;
}

- (id)initWithComponent:(Component)aComponent {
	self = [super init];
	if (self) {
		component = aComponent;
	}
	return self;
}

- (NSString *)name {
	ComponentDescription desc;
	Handle nameH = NewHandle (0);
	GetComponentInfo (component, &desc, nameH, nil, nil);
	HLock (nameH);
	NSString *name = [[NSString alloc] initWithCString:(*nameH)+1 length:GetHandleSize(nameH)-1];
	DisposeHandle (nameH);
	return name;
}

- (ComponentDescription)componentDescription {
	ComponentDescription desc;
	GetComponentInfo (component, &desc, nil, nil, nil);
	return desc;
}


@end
