//
//  TDThemeBitSource.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 31/05/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@class TDAsset;

@interface TDThemeBitSource : NSManagedObject

- (NSURL *)fileURLWithDocument:(CoreThemeDocument *)document;

@property (nonatomic, copy) NSString *name;

@property(nonatomic, readonly) NSSet <__kindof TDAsset *> *assets;
@property(nonatomic, copy) NSString *path;

@end