//
//  CoreThemeDocument+ArrayControllers.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 16/04/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "CoreThemeDocument+ArrayControllers.h"

@implementation CoreThemeDocument (ArrayControllers)

- (NSDictionary *)constantArrayControllers
{
    return self->constantArrayControllers;
}

- (NSDictionary *)cachedConstantArrays
{
    return self->cachedConstantArrays;
}

- (NSNumber *)physicalColorWithRed:(unsigned int)red green:(unsigned int)green blue:(unsigned int)blue alpha:(unsigned int)alpha
{
    unsigned int tmp1 = green << 0x8 & 0xffff;
    tmp1 = tmp1 | (red << 0x10 & 0xff0000);
    unsigned int tmp2 = (blue & 0xff) | tmp1;
    unsigned int output = (tmp2 | alpha << 0x18);
    
    return @(output);
}

@end
