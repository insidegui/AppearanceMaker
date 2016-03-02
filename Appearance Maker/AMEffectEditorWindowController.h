//
//  AMEffectEditorWindowController.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 02/03/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AMThemeDocument.h"

@class TDSchemaEffectDefinition;

@interface AMEffectEditorWindowController : NSWindowController

+ (AMEffectEditorWindowController *__nonnull)effectEditorWindowControllerWithEffectDefinition:(TDSchemaEffectDefinition *__nullable)effectDefinition document:(AMThemeDocument *__nonnull)document;

@property (nonatomic, weak) TDSchemaEffectDefinition *__nullable effectDefinition;

@end
