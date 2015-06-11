//
//  Document.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CoreThemeDocument.h"

@interface AMThemeDocument : CoreThemeDocument

@property (nonatomic, strong) NSArray <NSSortDescriptor *> *defaultSortDescriptors;

@end

