//
//  CoreThemeDocument+ArrayControllers.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 16/04/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "CoreThemeDefinition.h"

@interface CoreThemeDocument (ArrayControllers)

@property (nonatomic, readonly) NSDictionary *constantArrayControllers;

- (NSNumber *)physicalColorWithRed:(unsigned int)red green:(unsigned int)green blue:(unsigned int)blue alpha:(unsigned int)alpha;

@end
