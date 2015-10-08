//
//  Document.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMThemeDocument.h"

@interface AMThemeDocument ()

@end

@implementation AMThemeDocument
{
    TDThemeLook *_defaultLook;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)makeWindowControllers {
    NSWindowController *windowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"];
    [self addWindowController:windowController];
    [windowController.contentViewController setRepresentedObject:self];
    
    [super windowControllerDidLoadNib:windowController];
}

- (NSString *)persistentStoreTypeForFileType:(NSString *)type
{
    return NSSQLiteStoreType;
}

- (NSArray<NSSortDescriptor *> *)defaultSortDescriptors
{
    if (!_defaultSortDescriptors) _defaultSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES]];
    
    return _defaultSortDescriptors;
}

- (TDThemeLook *)defaultLook
{
    if (!_defaultLook) {
        NSArray *looks = [self objectsForEntity:@"ThemeLook" withPredicate:[NSPredicate predicateWithFormat:@"displayName = \"Luna\""] sortDescriptors:self.defaultSortDescriptors];
        _defaultLook = looks[0];
    }
    
    return _defaultLook;
}

- (IBAction)exportAppearance:(id)sender
{
    NSSavePanel *exportPanel = [NSSavePanel savePanel];
    exportPanel.allowedFileTypes = @[@"car"];
    exportPanel.title = NSLocalizedString(@"Export Appearance", @"Export Appearance panel title");
    exportPanel.prompt = NSLocalizedString(@"Export", @"Export");
    [exportPanel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSInteger result) {
        if (!result) return;
        
        TDDistillRunner *distiller = [[TDDistillRunner alloc] init];
        if (![distiller runDistillWithDocumentURL:self.fileURL outputURL:exportPanel.URL attemptIncremental:YES forceDistill:NO]) {
            NSLog(@"Distiller failed");
        }
    }];
}

@end
