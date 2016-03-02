//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Oct  7 2015 21:36:47).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <CoreData/NSManagedObject.h>

@class NSDate, NSNumber, NSSet, NSString, TDNamedElement, TDRenditionKeySpec, TDRenditionType, TDSchemaPartDefinition, TDThemeConstant;

@interface TDRenditionType : TDThemeConstant
@end

@interface TDElementProduction : NSManagedObject

- (void)deleteRenditionsInDocument:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2;
- (id)associatedFileModificationDateWithDocument:(id)arg1;
- (id)associatedFileURLWithDocument:(id)arg1;
- (id)relativePath;

// Remaining properties
@property(retain, nonatomic) TDThemeConstant *artworkDraftType; // @dynamic artworkDraftType;
@property(retain, nonatomic) TDRenditionKeySpec *baseKeySpec; // @dynamic baseKeySpec;
@property(retain, nonatomic) NSString *comment; // @dynamic comment;
@property(retain, nonatomic) NSDate *dateOfLastChange; // @dynamic dateOfLastChange;
@property(retain, nonatomic) NSNumber *isExcludedFromFilter; // @dynamic isExcludedFromFilter;
@property(nonatomic) BOOL makeOpaqueIfPossible; // @dynamic makeOpaqueIfPossible;
@property(retain, nonatomic) TDNamedElement *name; // @dynamic name;
@property(retain, nonatomic) TDSchemaPartDefinition *partDefinition; // @dynamic partDefinition;
@property(retain, nonatomic) TDThemeConstant *renditionSubtype; // @dynamic renditionSubtype;
@property(retain, nonatomic) TDRenditionType *renditionType; // @dynamic renditionType;
@property(retain, nonatomic) NSSet *renditions; // @dynamic renditions;
@property(retain, nonatomic) NSSet *tags; // @dynamic tags;
@property(retain, nonatomic) NSString *universalTypeIdentifier; // @dynamic universalTypeIdentifier;
@property(retain, nonatomic) TDThemeConstant *zeroCodeArtworkInfo; // @dynamic zeroCodeArtworkInfo;

@end

