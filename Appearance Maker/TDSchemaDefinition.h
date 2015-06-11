//
//  TDSchemaDefinition.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@class TDSchemaCategory;

@interface TDSchemaDefinition : NSManagedObject

+ (unsigned long long)elementDefinitionCountWithSchema:(id)arg1;
- (id)displayName;
- (id)previewImage;

@property(retain, nonatomic) TDSchemaCategory *category;
@property(retain, nonatomic) NSString *name;
@property(retain, nonatomic) NSSet *parts;
@property BOOL published;

@end

@interface TDSchemaElementDefinition : TDSchemaDefinition
@end

@interface TDSchemaEffectDefinition : TDSchemaDefinition
@end

@interface TDSchemaMaterialDefinition : TDSchemaDefinition
@end

@interface TDSchemaPartDefinition : NSManagedObject

@property(nonatomic) unsigned long long partFeatures; // @synthesize partFeatures;
@property(retain, nonatomic) NSArray *renditionGroups; // @synthesize renditionGroups;
@property(copy, nonatomic) NSArray *renditions; // @synthesize renditions;
@property(retain, nonatomic) NSImage *previewImage; // @synthesize previewImage;
- (void)didTurnIntoFault;
- (id)displayName;
- (long long)partID;
- (long long)elementID;
- (long long)_renditionKeyValueForTokenIdentifier:(unsigned short)arg1;
- (id)validStatesWithDocument:(id)arg1;
- (void)updateDerivedRenditionData;
- (id)_schema;
- (id)bestPreviewRendition;

@property(retain, nonatomic) TDSchemaDefinition *element;
@property(retain, nonatomic) NSString *name;
@property(retain, nonatomic) NSSet *productions;
@property(retain, nonatomic) NSString *widgetID;

@end