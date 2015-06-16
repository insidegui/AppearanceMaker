//
//  AMSystemUICatalog.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 15/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMSystemThemeStore.h"

#define kDefaultSystemCatalogName @"SystemAppearance"
#define kUICatalogExtension @"car"
#define kSystemAppearanceBundleName @"com.apple.systemappearance"

@implementation AMSystemThemeStore

+ (CUISystemStore *)defaultStore
{
    static CUISystemStore *_shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *carPath = [[[NSBundle bundleWithIdentifier:kSystemAppearanceBundleName] pathForResource:kDefaultSystemCatalogName ofType:kUICatalogExtension] UTF8String];
        setenv("COREUI_CAR_PATH", carPath, 0);
        
        _shared = [[CUISystemStore alloc] init];
    });
    
    return _shared;
}

+ (NSColor *)colorWithColorDef:(colordef_t)colorDef
{
    return [self colorWithPhysicalColor:@(colorDef.color)];
}

+ (NSColor *)colorWithPhysicalColor:(NSNumber *)physicalColor
{
    unsigned int color = physicalColor.intValue;
    
    unsigned int red = ((color & 0x00ff0000U) >> 16);
    unsigned int green = ((color & 0x0000ff00U) >> 8);
    unsigned int blue = (color & 0x000000ffU);
    unsigned int alpha = ((color & 0xff000000U) >> 24);
    
    return [NSColor colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

+ (NSNumber *)physicalColorWithColor:(NSColor *)color
{
    unsigned int red = 0;
    unsigned int green = 0;
    unsigned int blue = 0;
    unsigned int alpha = color.alphaComponent*255U;
    
    switch (color.numberOfComponents) {
        case 2:
            red = color.whiteComponent*255U;
            green = color.whiteComponent*255U;
            blue = color.whiteComponent*255U;
            break;
        case 4:
            red = color.redComponent*255U;
            green = color.greenComponent*255U;
            blue = color.blueComponent*255U;
            break;
    }

    unsigned int tmp1 = green << 0x8 & 0xffff;
    tmp1 = tmp1 | (red << 0x10 & 0xff0000);
    unsigned int tmp2 = (blue & 0xff) | tmp1;
    unsigned int output = (tmp2 | alpha << 0x18);
    
    return @(output);
}

@end