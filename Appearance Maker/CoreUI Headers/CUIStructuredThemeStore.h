//
//  CUIThemeStore.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 15/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

typedef struct rgbquad {
    unsigned int :8;
    unsigned int :8;
    unsigned int :8;
    unsigned int :8;
} rgbquad_t;

typedef struct colordef {
    unsigned int _field1;
    unsigned int _field2;
    unsigned int color;
} colordef_t;

@interface CUIStructuredThemeStore : NSObject

- (id)imagesWithName:(id)arg1;
- (id)allImageNames;
- (id)zeroCodeGlyphList;
- (unsigned int)authoredWithSchemaVersion;
- (unsigned int)distilledInCoreUIVersion;
- (unsigned int)documentFormatVersion;
- (id)themeStore;
- (id)initWithBytes:(const void *)arg1 length:(NSUInteger)arg2;
- (id)initWithURL:(id)arg1;
- (id)initWithPath:(id)arg1;
- (BOOL)usesCUISystemThemeRenditionKey;
- (long long)maximumRenditionKeyTokenCount;
- (unsigned long long)colorSpaceID;
- (id)bundleID;
- (BOOL)hasPhysicalColorWithName:(NSString *)name;
- (BOOL)getPhysicalColor:(colordef_t *)outDef withName:(NSString *)name;

@property(readonly, copy) NSString *debugDescription;
@property(nonatomic) unsigned long long themeIndex;

@end

@interface CUISystemStore : CUIStructuredThemeStore <NSCoding>

+ (BOOL)isUsingSharedSystemCache;
- (void)invalidateCache;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)catalogGlobals;
- (id)assetDataFromCacheWithKeySignature:(id)arg1;
- (BOOL)getPhysicalColor:(colordef_t *)outColor withName:(NSString *)name;
- (id)init;
- (id)_systemCarPath;
- (id)_systemCarBundle;

@end