//
//  AMSystemUICatalog.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 15/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "CUICatalog.h"

@interface AMSystemThemeStore : NSObject

+ (CUISystemStore *)defaultStore;

+ (NSColor *)colorWithColorDef:(colordef_t)colorDef;

+ (NSColor *)colorWithPhysicalColor:(NSNumber *)physicalColor;
+ (NSNumber *)physicalColorWithColor:(NSColor *)color;

+ (NSColor *)effectColorWithPhysicalColor:(NSNumber *)physicalColor;
+ (NSNumber *)effectPhysicalColorWithColor:(NSColor *)color;

@end
