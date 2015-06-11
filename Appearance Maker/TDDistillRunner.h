//
//  TDDistillRunner.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@interface TDLogger : NSObject

+ (instancetype)logger;

@end

@interface TDDistillRunner : NSObject

@property long long assetStoreVersionNumber; // @synthesize assetStoreVersionNumber=_assetStoreVersionNumber;
@property(copy) NSString *assetStoreVersionString; // @synthesize assetStoreVersionString=_assetStoreVersionString;
@property(retain, nonatomic) TDLogger *logger; // @synthesize logger=_logger;
@property(copy, nonatomic) NSURL *outputURL; // @synthesize outputURL=_outputURL;
- (void)dealloc;
- (BOOL)runDistillWithDocumentURL:(id)arg1 outputURL:(id)arg2 attemptIncremental:(BOOL)arg3 forceDistill:(BOOL)arg4;
@property(nonatomic) BOOL packImagesInDocument;
- (BOOL)_isDistillUnnecessaryForDocument:(id)arg1;
- (void)_moveScratchToOutputPath;
- (void)_removeScratchPath;
- (id)carScratchURL;
- (id)init;

@end