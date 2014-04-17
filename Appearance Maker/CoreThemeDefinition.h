//
//  CoreThemeDefinition.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 16/04/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

@interface TDThemeConstant : NSManagedObject
{
    int _identifier;
}

- (void)setAttributesFromCopyData:(id)arg1;
- (id)copyDataFromAttributes;
- (id)debugDescription;
- (id)constantName;
- (void)setConstantName:(id)arg1;
- (id)displayName;
- (void)setDisplayName:(id)arg1;
- (unsigned int)identifier;
- (void)setIdentifier:(unsigned int)arg1;

@end

@interface TDThemeState : TDThemeConstant
{
}

@end

@interface TDThemePresentationState : TDThemeConstant
{
}

@end

@interface TDThemeValue : TDThemeConstant
{
}

@end

@interface TDThemeSize : TDThemeConstant
{
}

@end

@interface TDThemeDirection : TDThemeConstant
{
}

@end

@interface TDThemePart : TDThemeConstant
{
}

- (id)debugDescription;

@end

@interface TDThemeElement : TDThemeConstant
{
}

- (id)debugDescription;

@end

@interface TDThemeLook : TDThemeConstant
{
    BOOL _supportsContrastAdjustment;
}

- (BOOL)supportsContrastAdjustment;
- (void)setSupportsContrastAdjustment:(BOOL)arg1;

@end

@interface TDIterationType : TDThemeConstant
{
}

@end

@interface TDThemeDrawingLayer : TDThemeConstant
{
}

@end

@interface TDThemeIdiom : TDThemeConstant
{
}

@end

@interface TDRenditionType : TDThemeConstant
{
}

@end

@interface TDRenditionSubtype : TDThemeConstant
{
}

@end

@interface TDSchemaCategory : TDThemeConstant
{
}


// Remaining properties
@property(retain, nonatomic) NSSet *elements; // @dynamic elements;
@end

/**
 CoreThemeDocument represents an uicatalog file and Its related assets,
 used to configure an appearance
 */
@interface CoreThemeDocument : NSPersistentDocument
{
    NSMutableDictionary *constantArrayControllers;
    NSMutableDictionary *cachedConstantArrays;
}

+ (id)defaultThemeBitSourceURLForDocumentURL:(id)arg1;
+ (void)doneWithColorConversion;
+ (int)shouldConvertColorsFromColorSpaceWithIdentifier:(unsigned long long)arg1 toIdentifier:(unsigned long long)arg2 error:(id *)arg3;
+ (unsigned long long)standardColorSpaceID;
+ (void)closeMigrationProgress;
+ (void)presentMigrationProgress;
+ (id)dataModelNameForVersion:(long long)arg1;
+ (long long)dataModelVersion;
+ (long long)targetPlatformForMOC:(id)arg1;
+ (long long)defaultTargetPlatform;
+ (long long)platformForPersistentString:(id)arg1;
+ (id)persistentStringForPlatform:(long long)arg1;
+ (id)_imageAssetURLsByCopyingFileURLs:(id)arg1 toManagedLocationAtURL:(id)arg2 error:(id *)arg3;
+ (id)migrateDocumentAtURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
+ (long long)dataModelVersionFromMetadata:(id)arg1;

/**
 @method createConfiguredDocumentAtURL:error:
 @abstract Creates a new uicatalog at the specified location
 @discussion
 This method creates a configured document at the specified URL,
 if the file already exists, It gets overwritten
 */
+ (id)createConfiguredDocumentAtURL:(NSURL *)documentURL error:(NSError **)outError;

+ (void)_addThemeDocument:(id)arg1;
+ (id)_sharedDocumentList;
@property(copy) NSString *pathToRepresentedDocument; // @synthesize pathToRepresentedDocument;
- (void)addThemeBitSourceAtPath:(id)arg1;
- (void)addThemeBitSourceAtPath:(id)arg1 createProductions:(BOOL)arg2;
@property(readonly, nonatomic) NSURL *themeBitSourceURL;
- (void)_configureAfterFirstSave;
- (void)_synchronousSave;
- (void)firstSaveDidEnd:(id)arg1 didSave:(BOOL)arg2 contextInfo:(void *)arg3;
- (void)windowControllerDidLoadNib:(id)arg1;

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;

- (BOOL)checkCompatibilityOfDocumentAtURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
- (BOOL)writeSafelyToURL:(id)arg1 ofType:(id)arg2 forSaveOperation:(unsigned long long)arg3 error:(id *)arg4;
- (BOOL)configurePersistentStoreCoordinatorForURL:(id)arg1 ofType:(id)arg2 modelConfiguration:(id)arg3 storeOptions:(id)arg4 error:(id *)arg5;
- (id)updatedVersionsMetadataFromMetadata:(id)arg1;
- (id)persistentStoreTypeForFileType:(id)arg1;

// TODO: mess around with these
- (void)importCursorsFromURL:(id)arg1 getUnusedImportedCursors:(id *)arg2 getUnupdatedCursors:(id *)arg3;
- (void)exportCursorsToURL:(id)arg1;
- (void)importColorsFromURL:(id)arg1 valuesOnly:(BOOL)arg2 getUnusedColorNames:(id *)arg3;
- (void)exportColorsToURL:(id)arg1;

- (id)namedEffectProductions;
- (id)namedArtworkProductions;

- (TDThemeConstant *)schemaPartDefinitionWithElementID:(NSInteger)elementID partID:(NSInteger)partID;
- (TDThemeConstant *)schemaDefinitionWithElementID:(NSInteger)elementID;

- (BOOL)customizeSchemaPartDefinition:(TDThemeConstant *)part usingArtworkFormat:(NSString *)format shouldReplaceExisting:(BOOL)replace error:(NSError **)outError;
- (BOOL)customizeSchemaEffectDefinition:(TDThemeConstant *)part shouldReplaceExisting:(BOOL)replace error:(NSError **)outError;
- (BOOL)customizeSchemaElementDefinition:(TDThemeConstant *)part usingArtworkFormat:(NSString *)format shouldReplaceExisting:(BOOL)replace error:(NSError **)outError;

- (void)removeCustomizationForSchemaDefinition:(TDThemeConstant *)definition shouldDeleteAssetFiles:(BOOL)shouldDelete;
- (BOOL)customizationExistsForSchemaDefinition:(TDThemeConstant *)definition;

- (id)_customizedSchemaDefinitionsForEntity:(id)arg1;

- (NSArray *)customizedSchemaEffectDefinitions;
- (NSArray *)customizedSchemaElementDefinitions;

- (BOOL)usesCUISystemThemeRenditionKey;
- (long long)renditionKeySpecAttributeCount;
- (int)renditionKeySemantics;
- (const struct _renditionkeyfmt *)renditionKeyFormat;
- (void)convertColorsFromColorSpaceWithIdentifier:(unsigned long long)arg1 toIdentifier:(unsigned long long)arg2;
- (id)colorSpaceByIdentifier:(unsigned long long)arg1;
- (unsigned long long)colorSpaceID;
- (BOOL)didMigrate;
- (void)primeArrayControllers;
- (void)resetThemeConstants;
- (void)buildModel;
- (long long)targetPlatform;

- (void)setTargetPlatform:(NSInteger)platformID;
- (void)setArtworkFormat:(NSString *)formatName;
- (NSString *)artworkFormat;

- (unsigned int)checksum;
- (void)setUuid:(id)arg1;
- (id)uuid;
- (unsigned long long)countOfRenditionsMatchingRenditionKeySpecs:(id)arg1;
- (unsigned long long)countOfRenditionsMatchingRenditionKeySpec:(id)arg1;
- (id)renditionsMatchingRenditionKeySpec:(id)arg1;
- (BOOL)isCustomLook;
- (void)setRelativePathToProductionData:(id)arg1;
- (id)relativePathToProductionData;
- (id)rootPathForProductionData;
- (id)pathToAsset:(id)arg1;

- (void)setMetadatum:(id)arg1 forKey:(id)arg2;
- (id)metadatumForKey:(id)arg1;

- (id)_addAssetsAtFileURLs:(id)arg1 createProductions:(BOOL)arg2 referenceFiles:(BOOL)arg3 bitSource:(id)arg4 customInfos:(id)arg5 sortedCustomInfos:(id *)arg6;
- (id)addAssetsAtFileURLs:(id)arg1 createProductions:(BOOL)arg2 referenceFiles:(BOOL)arg3 bitSource:(id)arg4 customInfos:(id)arg5;
- (id)addAssetsAtFileURLs:(id)arg1 createProductions:(BOOL)arg2;
- (id)addAssetsAtFileURLs:(id)arg1;
- (id)assetAtFileURL:(id)arg1;
- (id)assetAtPath:(id)arg1;

- (id)createAssetWithName:(id)arg1 fileType:(id)arg2 scaleFactor:(unsigned int)arg3 inCategory:(id)arg4 forThemeBitSource:(id)arg5;
- (id)createAssetWithName:(id)arg1 scaleFactor:(unsigned int)arg2 inCategory:(id)arg3 forThemeBitSource:(id)arg4;
- (id)createAssetWithName:(id)arg1 inCategory:(id)arg2 forThemeBitSource:(id)arg3;
- (id)createElementProductionWithAsset:(id)arg1;

- (id)_genericPartDefinition;
- (void)deleteNamedAssets:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2 completionHandler:(id)arg3;
- (void)importNamedAssetsWithImportInfos:(id)arg1 referenceFiles:(BOOL)arg2 completionHandler:(id)arg3;
- (void)importNamedAssetsWithImportInfos:(id)arg1 completionHandler:(id)arg2;
- (void)importNamedAssetsFromFileURLs:(id)arg1 referenceFiles:(BOOL)arg2 completionHandler:(id)arg3;
- (id)createNamedArtworkProductionsForAssets:(id)arg1 customInfos:(id)arg2 error:(id *)arg3;
- (id)namedArtworkProductionWithName:(id)arg1;
- (id)_createNamedElementWithIdentifier:(long long)arg1;
- (id)_createNamedElementWithNextAvailableIdentifier;
- (id)_namedImagePartDefinition;
- (id)_createPhotoshopElementProductionWithAsset:(id)arg1;
- (id)createNamedEffectProductionWithName:(id)arg1 isText:(BOOL)arg2;
- (id)_namedImageEffectPartDefinition;
- (id)_namedTextEffectPartDefinition;
- (id)namedEffectProductionWithName:(id)arg1;
- (id)createEffectStyleProductionForPartDefinition:(id)arg1 withNameIdentifier:(id)arg2;
- (id)createEffectStyleProductionForPartDefinition:(id)arg1;
- (void)_normalizeRenditionKeySpec:(id)arg1 forSchemaRendition:(id)arg2;
- (id)createProductionWithRenditionGroup:(id)arg1 forPartDefinition:(id)arg2 artworkFormat:(id)arg3 shouldReplaceExisting:(BOOL)arg4 error:(id *)arg5;

- (BOOL)createPSDReferenceArtworkForRenditionGroup:(id)arg1 atDestination:(id)arg2 error:(id *)arg3;
- (BOOL)shouldGeneratePSDAssetFromArtFile:(id)arg1;

- (id)handCraftedAssetURLForFileName:(id)arg1;
- (id)_themeBitSourceForReferencedFilesAtURLs:(id)arg1 createIfNecessary:(BOOL)arg2;
- (id)_themeBitSource:(id *)arg1;
- (id)createReferencePNGForSchemaRendition:(id)arg1 withPartDefinition:(id)arg2 atLocation:(id)arg3 error:(id *)arg4;
- (id)defaultPathComponentsForPartDefinition:(id)arg1;
- (id)defaultBaseFileNameForSchemaRendition:(id)arg1 withPartDefinition:(id)arg2;
- (id)defaultPNGFileNameForSchemaRendition:(id)arg1 withPartDefinition:(id)arg2;
- (id)folderNameFromRenditionKey:(id)arg1 forPartDefinition:(id)arg2;
- (id)minimalDisplayNameForThemeConstant:(id)arg1;
- (void)deleteProductions:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2;
- (void)deleteProduction:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2;
- (void)deleteObject:(id)arg1;
- (void)deleteObjects:(id)arg1;
- (id)newObjectForEntity:(id)arg1;
- (unsigned long long)countForEntity:(id)arg1 withPredicate:(id)arg2;
- (id)objectsForEntity:(id)arg1 withPredicate:(id)arg2 sortDescriptors:(id)arg3 error:(id *)arg4;
- (id)objectsForEntity:(id)arg1 withPredicate:(id)arg2 sortDescriptors:(id)arg3;
- (id)allObjectsForEntity:(id)arg1 withSortDescriptors:(id)arg2 error:(id *)arg3;
- (id)allObjectsForEntity:(id)arg1 withSortDescriptors:(id)arg2;
- (id)mappingForPhotoshopLayerIndex:(long long)arg1 themeDrawingLayerIdentifier:(long long)arg2;
- (id)artworkDraftTypeWithIdentifier:(long long)arg1;
- (id)zeroCodeArtworkInfoWithIdentifier:(long long)arg1;
- (id)psdImageRefForAsset:(id)arg1;
- (id)constantWithName:(id)arg1 forIdentifier:(long long)arg2;

- (id)iterationTypeWithIdentifier:(int)arg1;
- (id)renditionSubtypeWithIdentifier:(unsigned int)arg1;
- (id)renditionTypeWithIdentifier:(long long)arg1;
- (id)effectComponentWithType:(unsigned int)arg1 inRendition:(id)arg2 createIfNeeded:(BOOL)arg3;
- (id)effectParameterValueWithType:(unsigned int)arg1 inComponent:(id)arg2 createIfNeeded:(BOOL)arg3;
- (id)effectParameterTypeWithIdentifier:(unsigned int)arg1;
- (id)effectTypeWithIdentifier:(unsigned int)arg1;
- (id)schemaCategoryWithIdentifier:(long long)arg1;
- (id)lookWithIdentifier:(long long)arg1;
- (id)idiomWithIdentifier:(long long)arg1;
- (id)drawingLayerWithIdentifier:(long long)arg1;
- (id)valueWithIdentifier:(long long)arg1;
- (id)presentationStateWithIdentifier:(long long)arg1;
- (id)stateWithIdentifier:(long long)arg1;
- (id)directionWithIdentifier:(long long)arg1;
- (id)sizeWithIdentifier:(long long)arg1;
- (id)partWithIdentifier:(long long)arg1;
- (id)elementWithIdentifier:(long long)arg1;
- (id)themeConstant:(id)arg1 withIdentifier:(long long)arg2;

- (id)_cachedConstantsForEntity:(id)arg1;
- (void)recacheThemeConstant:(id)arg1;
- (id)arrayControllerForConstant:(id)arg1;
- (id)historian;
- (id)mocOrganizer;
- (id)managedObjectModel;
- (id)updateToEmbeddedSchemaVersion2AndReturnAlertString:(id *)arg1;
- (id)updateToSchemaVersion4AndReturnAlertString:(id *)arg1;
- (id)updateToSchemaVersion3AndReturnAlertString:(id *)arg1;
- (id)migrateFromWindowFormat14ToWindowFormat15:(id *)arg1;
- (void)checkVersionsAndUpdateIfNecessary;
- (void)dealloc;
- (id)initWithContentsOfURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
- (id)initForURL:(id)arg1 withContentsOfURL:(id)arg2 ofType:(id)arg3 error:(id *)arg4;
- (id)initWithType:(id)arg1 error:(id *)arg2;
- (id)initWithType:(id)arg1 targetPlatform:(long long)arg2 error:(id *)arg3;
- (id)init;
- (void)_getFilename:(id *)arg1 scaleFactor:(unsigned int *)arg2 category:(id *)arg3 bitSource:(id *)arg4 forFileURL:(id)arg5;
- (id)_predicateForRenditionKeySpec:(id)arg1;
- (void)changedObjectsNotification:(id)arg1;

@end