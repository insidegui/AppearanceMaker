//
//  TDThemeConstant.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@interface TDThemeConstant : NSManagedObject

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