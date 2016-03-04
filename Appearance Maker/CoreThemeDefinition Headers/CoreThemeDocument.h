//
//  CoreThemeDocument.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

#import "TDSchemaCategory.h"
#import "TDSchemaDefinition.h"
#import "TDEffectStyleProduction.h"
#import "TDNamedEffectProduction.h"
#import "TDDistillRunner.h"
#import "TDColor.h"
#import "TDAsset.h"

@protocol TDAssetManagementDelegate <NSObject>

@optional

- (void)willDeleteAsset:(__kindof TDAsset *)asset atURL:(NSURL *)URL;
- (void)didDeleteAssetAtURL:(NSURL *)URL;

- (void)willCreateAssetAtURL:(NSURL *)URL;
- (void)didCreateAsset:(__kindof TDAsset *)asset atURL:(NSURL *)URL;

@end

@interface CoreThemeDocument : NSPersistentDocument

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
+ (id)migrateDocumentAtURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
+ (long long)dataModelVersionFromMetadata:(id)arg1;
+ (id)createConfiguredDocumentAtURL:(id)arg1 error:(id *)arg2;
+ (int)maximumAreaOfPackableImageForScale:(unsigned long long)arg1;
+ (void)initialize;

//@property(nonatomic) id <TDCustomAssetProvider> customAssetProvider; // @synthesize customAssetProvider=_customAssetProvider;
@property(nonatomic) id <TDAssetManagementDelegate> assetManagementDelegate; // @synthesize assetManagementDelegate=_assetManagementDelegate;
@property(copy) NSString *pathToRepresentedDocument; // @synthesize pathToRepresentedDocument;
@property(copy, nonatomic) NSString *minimumDeploymentVersion; // @synthesize minimumDeploymentVersion=_minimumDeploymentVersion;
//@property(retain, nonatomic) TDDeviceTraits *optimizeForDeviceTraits; // @synthesize optimizeForDeviceTraits=_optimizeForDeviceTraits;
@property(nonatomic) long long documentCapabilities; // @synthesize documentCapabilities=_capabilities;

- (void)packRenditions;
- (void)addThemeBitSourceAtPath:(id)arg1;
- (void)addThemeBitSourceAtPath:(id)arg1 createProductions:(BOOL)arg2;
@property(readonly, nonatomic) NSURL *themeBitSourceURL;
- (BOOL)canAsynchronouslyWriteToURL:(id)arg1 ofType:(id)arg2 forSaveOperation:(unsigned long long)arg3;
- (void)firstSaveDidEnd:(id)arg1 didSave:(BOOL)arg2 contextInfo:(void *)arg3;
- (void)windowControllerDidLoadNib:(id)arg1;
- (BOOL)readFromURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
- (BOOL)checkCompatibilityOfDocumentAtURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
- (BOOL)writeSafelyToURL:(id)arg1 ofType:(id)arg2 forSaveOperation:(unsigned long long)arg3 error:(id *)arg4;
- (BOOL)configurePersistentStoreCoordinatorForURL:(id)arg1 ofType:(id)arg2 modelConfiguration:(id)arg3 storeOptions:(id)arg4 error:(id *)arg5;
- (id)updatedVersionsMetadataFromMetadata:(id)arg1;
- (id)persistentStoreTypeForFileType:(id)arg1;
@property(nonatomic) BOOL allowsVibrancy;
@property(nonatomic) int defaultBlendMode;

- (void)importCursorsFromURL:(NSURL *)url getUnusedImportedCursors:(NSArray **)unusedImportedCursors getUnupdatedCursors:(NSArray **)unupdatedCursors;
- (void)exportCursorsToURL:(NSURL *)url;
- (void)importColorsFromURL:(NSURL *)url valuesOnly:(BOOL)valuesOnly getUnusedColorNames:(NSArray **)outNames;
- (void)exportColorsToURL:(NSURL *)url;

- (id)namedEffectProductions;
- (id)namedArtworkProductions;
- (id)schemaPartDefinitionWithElementID:(long long)arg1 partID:(long long)arg2;
- (id)schemaDefinitionWithElementID:(long long)arg1;

- (BOOL)customizeSchemaPartDefinition:(id)arg1 usingArtworkFormat:(id)arg2 nameElement:(id)arg3 shouldReplaceExisting:(BOOL)arg4 error:(id *)arg5;
- (BOOL)customizeSchemaMaterialDefinition:(id)arg1 shouldReplaceExisting:(BOOL)arg2 error:(id *)arg3;
- (BOOL)customizeSchemaEffectDefinition:(id)arg1 shouldReplaceExisting:(BOOL)arg2 error:(id *)arg3;
- (BOOL)customizeSchemaElementDefinition:(id)arg1 usingArtworkFormat:(id)arg2 shouldReplaceExisting:(BOOL)arg3 error:(id *)arg4;

- (void)removeCustomizationForSchemaDefinition:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2;
- (BOOL)customizationExistsForSchemaDefinition:(id)arg1;
- (id)customizedSchemaMaterialDefinitions;
- (id)customizedSchemaEffectDefinitions;
- (id)customizedSchemaElementDefinitions;
- (BOOL)usesCUISystemThemeRenditionKey;
- (long long)renditionKeySpecAttributeCount;
- (int)renditionKeySemantics;
//- (const struct _renditionkeyfmt *)renditionKeyFormat;
- (void)convertColorsFromColorSpaceWithIdentifier:(unsigned long long)arg1 toIdentifier:(unsigned long long)arg2;
- (id)colorSpaceByIdentifier:(unsigned long long)arg1;
- (unsigned long long)colorSpaceID;
- (BOOL)didMigrate;
- (void)primeArrayControllers;
- (void)resetThemeConstants;
- (void)buildModel;
- (long long)targetPlatform;
- (void)setTargetPlatform:(long long)arg1;
- (void)setArtworkFormat:(id)arg1;
- (id)artworkFormat;
- (unsigned int)checksum;
@property(copy, nonatomic) NSUUID *uuid;
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
- (id)addAssetsAtFileURLs:(id)arg1 createProductions:(BOOL)arg2 referenceFiles:(BOOL)arg3 bitSource:(id)arg4 customInfos:(id)arg5;
- (id)addAssetsAtFileURLs:(id)arg1 createProductions:(BOOL)arg2;
- (id)addAssetsAtFileURLs:(id)arg1;
- (id)assetAtFileURL:(id)arg1;
- (id)assetAtPath:(id)arg1;
- (id)createAssetWithName:(id)arg1 fileType:(id)arg2 scaleFactor:(unsigned int)arg3 inCategory:(id)arg4 forThemeBitSource:(id)arg5;
- (id)createAssetWithName:(id)arg1 scaleFactor:(unsigned int)arg2 inCategory:(id)arg3 forThemeBitSource:(id)arg4;
- (id)createAssetWithName:(id)arg1 inCategory:(id)arg2 forThemeBitSource:(id)arg3;
- (id)createElementProductionWithAsset:(id)arg1;
//- (void)importCustomAssetsWithImportInfos:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (BOOL)createCustomArtworkProductionsForCustomAssets:(id)arg1 withImportInfos:(id)arg2 error:(id *)arg3;
//- (void)deleteNamedAssets:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2 completionHandler:(CDUnknownBlockType)arg3;
//- (void)importNamedAssetsWithImportInfos:(id)arg1 referenceFiles:(BOOL)arg2 completionHandler:(CDUnknownBlockType)arg3;
//- (void)importNamedAssetsWithImportInfos:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
//- (void)importNamedAssetsFromFileURLs:(id)arg1 referenceFiles:(BOOL)arg2 completionHandler:(CDUnknownBlockType)arg3;
- (id)createNamedArtworkProductionsForAssets:(id)arg1 customInfos:(id)arg2 error:(id *)arg3;
//- (id)slicesComputedForImageSize:(struct CGSize)arg1 usingSliceInsets:(CDStruct_3c058996)arg2 resizableSliceSize:(struct CGSize)arg3 withRenditionType:(long long)arg4;
- (id)namedArtworkProductionWithName:(id)arg1;
- (id)elementProductionsWithName:(id)arg1;
- (id)namedElementsForElementDefinition:(id)arg1;
- (id)namedElementWithName:(id)arg1;

- (TDNamedEffectProduction *)createNamedEffectProductionWithName:(NSString *)name isText:(BOOL)flag;

- (id)namedEffectProductionWithName:(id)arg1;
- (id)createEffectStyleProductionForPartDefinition:(id)arg1 withNameIdentifier:(id)arg2;
- (TDEffectStyleProduction *)createEffectStyleProductionForPartDefinition:(TDSchemaPartDefinition *)part;

- (id)createProductionWithRenditionGroup:(id)arg1 forPartDefinition:(id)arg2 artworkFormat:(id)arg3 nameElement:(id)arg4 shouldReplaceExisting:(BOOL)arg5 error:(id *)arg6;
- (id)createProductionWithRenditionGroup:(id)arg1 forPartDefinition:(id)arg2 artworkFormat:(id)arg3 shouldReplaceExisting:(BOOL)arg4 error:(id *)arg5;
- (BOOL)allowMultipleInstancesOfElementID:(long long)arg1;
- (BOOL)createPSDReferenceArtworkForRenditionGroup:(id)arg1 atDestination:(id)arg2 error:(id *)arg3;
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

- (__kindof NSManagedObject *)newObjectForEntity:(NSString *)entityName;
- (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray <__kindof NSManagedObject *> *)objectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors error:(NSError **)outError;
- (NSArray <__kindof NSManagedObject *> *)objectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors;

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
- (id)templateRenderingModeWithIdentifier:(long long)arg1;
- (id)sizeClassWithIdentifier:(long long)arg1;
- (id)graphicsFeatureSetClassWithIdentifier:(long long)arg1;
- (id)idiomWithIdentifier:(long long)arg1;
- (id)drawingLayerWithIdentifier:(long long)arg1;
- (id)previousValueWithIdentifier:(long long)arg1;
- (id)valueWithIdentifier:(long long)arg1;
- (id)presentationStateWithIdentifier:(long long)arg1;
- (id)previousStateWithIdentifier:(long long)arg1;
- (id)stateWithIdentifier:(long long)arg1;
- (id)directionWithIdentifier:(long long)arg1;
- (id)sizeWithIdentifier:(long long)arg1;
- (id)partWithIdentifier:(long long)arg1;
- (id)elementWithIdentifier:(long long)arg1;
- (id)themeConstant:(id)arg1 withIdentifier:(long long)arg2;
- (void)recacheThemeConstant:(id)arg1;

- (NSArrayController *)arrayControllerForConstant:(id)constant;

- (id)historian;
- (id)mocOrganizer;

- (NSManagedObjectModel *)managedObjectModel;

- (id)updateToEmbeddedSchemaVersion2AndReturnAlertString:(id *)arg1;
- (void)checkVersionsAndUpdateIfNecessary;
- (id)initWithContentsOfURL:(id)arg1 ofType:(id)arg2 error:(id *)arg3;
- (id)initForURL:(id)arg1 withContentsOfURL:(id)arg2 ofType:(id)arg3 error:(id *)arg4;
- (id)initWithType:(id)arg1 error:(id *)arg2;
- (id)initWithType:(id)arg1 targetPlatform:(long long)arg2 error:(id *)arg3;
- (id)init;
- (void)changedObjectsNotification:(id)arg1;
- (void)updateRenditionSpec:(id)arg1;
@property(readonly, nonatomic) int patchVersion;
@property(readonly, nonatomic) int minorVersion;
@property(readonly, nonatomic) int majorVersion;

@end