//
//  CUICatalog.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 15/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

#import "CUIStructuredThemeStore.h"

@interface CUICatalog : NSObject

+ (__kindof CUICatalog *)defaultUICatalogForBundle:(id)variant;
+ (__kindof CUICatalog *)systemUICatalog;
+ (__kindof CUICatalog *)defaultUICatalog;
+ (__kindof CUICatalog *)systemUICatalogWithArtVariant:(id)variant;

- (__kindof CUICatalog *)initWithURL:(NSURL *)anURL error:(id *)arg2;
- (__kindof CUICatalog *)initWithName:(NSString *)aName fromBundle:(NSBundle *)aBundle error:(NSError **)outError;
- (__kindof CUICatalog *)initWithName:(NSString *)aName fromBundle:(NSBundle *)aBundle;

- (__kindof CUIStructuredThemeStore *)_themeStore;
- (NSArray *)imagesWithName:(id)arg1;
- (NSArray<NSString *> *)allImageNames;
- (BOOL)imageExistsWithName:(NSString *)imageName scaleFactor:(double)factor;
- (id)imageWithName:(NSString *)imageName scaleFactor:(double)factor;

- (BOOL)hasCustomizedAppearanceForWidget:(id)widget;

@end