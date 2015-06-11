//
//  TDColor.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@interface TDThemeLook : TDThemeConstant

- (BOOL)supportsContrastAdjustment;
- (void)setSupportsContrastAdjustment:(BOOL)arg1;

@end

@interface TDColorName : NSManagedObject

@property(retain, nonatomic) NSSet *colorDefinitions;
@property(retain, nonatomic) NSString *colorDescription;
@property(retain, nonatomic) NSString *displayName;
@property(retain, nonatomic) NSString *illustrationURL;
@property(retain, nonatomic) NSNumber *isExcludedFromFilter;
@property(retain, nonatomic) NSString *selector;

@end

@interface TDColorDefinition : NSManagedObject

- (NSString *)colorAsString;
- (void)setAttributesFromCopyData:(NSData *)data;
- (NSData *)copyDataFromAttributes;
- (void)setAttributesFromData:(NSData *)data;
- (NSData *)dataFromAttributes;
- (void)copyAttributesInto:(id)arg1;

@property(retain, nonatomic) NSManagedObject *colorStatus;
@property(retain, nonatomic) NSDate *dateOfLastChange;
@property(retain, nonatomic) TDThemeLook *look;
@property(retain, nonatomic) TDColorName *name;
@property(retain, nonatomic) NSNumber *physicalColor;

@end