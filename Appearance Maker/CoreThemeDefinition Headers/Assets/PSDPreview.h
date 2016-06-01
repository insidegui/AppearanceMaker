//
//  CTDPsdPreviewRef.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 31/05/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@interface CTDPSDPreviewRef : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (long long)indexOfDrawingLayerType:(long long)arg1;
- (id)createImageFromVerticalSlices:(id)arg1 horizontalSliceCount:(unsigned int)arg2 atLayer:(unsigned int)arg3;
- (id)createImageOfGradientAtLayer:(unsigned int)arg1;
- (id)createSlicedImageAtLayer:(unsigned int)arg1 overlayAlphaChannel:(long long)arg2;
- (id)createSlicedImageAtLayer:(unsigned int)arg1;
- (id)imagePreviewAtLayer:(unsigned int)arg1 overlayAlphaChannel:(long long)arg2;
- (long long)numberOfAlphaChannels;
- (long long)numberOfGradientLayers;
- (BOOL)hasGradient;
- (BOOL)hasRegularSliceGrid;
- (void)evaluateSliceGrid;
- (long long)sliceColumnCount;
- (long long)sliceRowCount;


@end

@interface TDPhotoshopElementProduction : TDElementProduction

- (CTDPSDPreviewRef *)psdImageRefWithDocument:(CoreThemeDocument *)document;

+ (unsigned int)sliceColumnsPerRendition:(long long)arg1;
+ (unsigned int)sliceRowsPerRendition:(long long)arg1;
- (void)setAttributesFromCopyData:(id)arg1;
- (id)copyDataFromAttributes;
- (void)setAttributesFromData:(id)arg1;
- (id)dataFromAttributes;
- (void)copyAttributesInto:(id)arg1;
- (void)deleteRenditionsInDocument:(id)arg1 shouldDeleteAssetFiles:(BOOL)arg2;
- (BOOL)generateRenditionsWithEntityName:(id)arg1 document:(id)arg2 errorDescription:(id *)arg3;
- (void)appendToLog:(id)arg1;
- (id)log;
- (id)baselineMetricsMaskWithDocument:(id)arg1;
- (id)textMetricsMaskWithDocument:(id)arg1;
- (id)edgeMetricsMaskWithDocument:(id)arg1;
- (void)fillIterationKeyAttribute:(id)arg1 iteration:(int)arg2 rowOrColumn:(int)arg3 document:(id)arg4;
- (void)getDrawingLayerIndices:(id *)arg1 themeLayers:(id *)arg2 lowestIndex:(long long *)arg3;
- (void)addDrawingLayerIndex:(id)arg1 themeLayer:(id)arg2 toIndices:(id)arg3 layers:(id)arg4 lowestIndex:(long long *)arg5;
- (id)associatedFileURLWithDocument:(id)arg1;
- (id)relativePath;
- (void)setRowIterationType:(id)arg1;
- (void)setColumnIterationType:(id)arg1;
- (void)setIsActive:(id)arg1;
- (id)baseKeySpec;
- (id)isActive;
- (id)rowIterationType;
- (id)columnIterationType;
- (void)setColumnCount:(id)arg1;
- (id)columnCount;
- (void)setRowCount:(id)arg1;
- (id)rowCount;

@property(nonatomic, strong) TDPhotoshopAsset *asset;

@end

@interface CTDPhotoshopAssetView : NSView

@property(nonatomic, copy) NSArray *layerIndexLayout;
@property(nonatomic, copy) NSArray *layerNames;
@property(nonatomic, strong) CTDPSDPreviewRef *psdImageRef;

- (void)clipViewFrameOrBoundsDidChangeNotification:(id)arg1;
- (BOOL)acceptsNotificationFromClipView:(id)arg1;
- (NSInteger)sliceColumnCount;
- (NSInteger)sliceRowCount;
- (BOOL)hasRegularSliceGrid;
- (void)setAlphaChannelIndex:(NSInteger)arg1;
- (void)evaluateSliceGrid;
- (void)tileLayersForClipView:(id)arg1;
- (id)gridNodesInRect:(NSPoint)arg1;
- (NSPoint)labelPointForGridNode:(NSInteger)arg1;
- (NSPoint)imagePointForGridNode:(NSInteger)arg1;
- (void)getRow:(NSInteger *)arg1 column:(NSInteger *)arg2 forLayerIndex:(long long)arg3;
- (void)createLayerNames;

@end