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

+ (NSColor *)effectColorWithPhysicalColor:(NSNumber *)physicalColor
{
    unsigned long color = (long)physicalColor.integerValue;
    
    unsigned char blue = color >> 16;
    unsigned char green = color >> 8;
    unsigned char red = color;
    
    CGFloat redFloat = red / 255.0;
    CGFloat greenFloat = green / 255.0;
    CGFloat blueFloat = blue / 255.0;
    
    return [NSColor colorWithCalibratedRed:redFloat green:greenFloat blue:blueFloat alpha:1.0];
}

+ (NSColor *)colorWithPhysicalColor:(NSNumber *)physicalColor
{
    unsigned long color = (long)physicalColor.integerValue;
    
    unsigned char blue = color;
    unsigned char green = color >> 8;
    unsigned char red = color >> 16;
    unsigned char alpha = color >> 24;
    
    CGFloat redFloat = red / 255.0;
    CGFloat greenFloat = green / 255.0;
    CGFloat blueFloat = blue / 255.0;
    CGFloat alphaFloat = alpha / 255.0;
    
    return [NSColor colorWithCalibratedRed:redFloat green:greenFloat blue:blueFloat alpha:alphaFloat];
}

+ (NSNumber *)effectPhysicalColorWithColor:(NSColor *)color
{
    unsigned char red = 0;
    unsigned char green = 0;
    unsigned char blue = 0;
    unsigned char alpha = color.alphaComponent*255;
    
    switch (color.numberOfComponents) {
        case 2:
            red = color.whiteComponent*255;
            green = color.whiteComponent*255;
            blue = color.whiteComponent*255;
            break;
        case 4:
            red = color.redComponent*255;
            green = color.greenComponent*255;
            blue = color.blueComponent*255;
            break;
    }
    
    NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X%02X", red, green, blue, alpha];
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    
    unsigned int number = 0;
    [scanner scanHexInt:&number];
    
    return @(number);
}

+ (NSNumber *)physicalColorWithColor:(NSColor *)color
{
    unsigned char red = 0;
    unsigned char green = 0;
    unsigned char blue = 0;
    unsigned char alpha = color.alphaComponent*255;
    
    switch (color.numberOfComponents) {
        case 2:
            red = color.whiteComponent*255;
            green = color.whiteComponent*255;
            blue = color.whiteComponent*255;
            break;
        case 4:
            red = color.redComponent*255;
            green = color.greenComponent*255;
            blue = color.blueComponent*255;
            break;
    }

    NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X%02X", blue, green, red, alpha];
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    
    unsigned long long number = 0;
    [scanner scanHexLongLong:&number];
    
    return @(number);
}

@end