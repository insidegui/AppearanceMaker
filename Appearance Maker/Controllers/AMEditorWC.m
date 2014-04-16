//
//  AMEditorWC.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 16/04/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "AMEditorWC.h"

#import "CoreThemeDefinition.h"
#import "CoreThemeDocument+ArrayControllers.h"

@interface AMEditorWC ()

@property (weak) IBOutlet NSButton *makeNewAppearanceButton;
@property (weak) IBOutlet NSPopUpButton *imageFormatPopUp;
@property (weak) IBOutlet NSButton *createSkeletonButton;
@property (weak) IBOutlet NSButton *exportAppearanceButton;

@property (copy) NSURL *catalogURL;

@property (strong) CoreThemeDocument *tdd;
@property (strong) NSTask *distiller;

@end

@implementation AMEditorWC

- (id)init
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    self.window.backgroundColor = [NSColor whiteColor];
    [self.window setMovableByWindowBackground:YES];
    
    // a demonstration that this actually works :)
    self.window.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@"AMEditorAppearance" bundle:nil];
    
    [self.imageFormatPopUp setEnabled:NO];
    [self.createSkeletonButton setEnabled:NO];
    [self.exportAppearanceButton setEnabled:NO];
    
    [self.makeNewAppearanceButton setKeyEquivalent:@"\r"];
}

- (IBAction)newAppearance:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:@[@"uicatalog"]];
    [savePanel setPrompt:@"Save"];
    [savePanel setTitle:@"Save UI Catalog File"];
    
    if (![savePanel runModal]) return;
    
    self.catalogURL = savePanel.URL;
    
    NSError *error;
    self.tdd = [CoreThemeDocument createConfiguredDocumentAtURL:self.catalogURL error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return;
    }
    
    [self.makeNewAppearanceButton setKeyEquivalent:@""];
    [self.createSkeletonButton setKeyEquivalent:@"\r"];
    [self.createSkeletonButton setEnabled:YES];
    [self.imageFormatPopUp setEnabled:YES];
}

- (NSString *)artworkFormat
{
    return [[self.imageFormatPopUp selectedItem].title lowercaseString];
}

- (void)customizeSchemaDefinitions
{
    for (int i = 0; i < 2000; i++) {
        if ([[[self.tdd elementWithIdentifier:i] displayName].lowercaseString rangeOfString:@"effect"].location != NSNotFound) {
            [self.tdd customizeSchemaEffectDefinition:[self.tdd schemaDefinitionWithElementID:i] shouldReplaceExisting:NO error:nil];
        } else {
            [self.tdd customizeSchemaElementDefinition:[self.tdd schemaDefinitionWithElementID:i] usingArtworkFormat:[self artworkFormat] shouldReplaceExisting:NO error:nil];
        }
    }
    
//    for (NSString *key in self.tdd.constantArrayControllers.allKeys) {
//        NSLog(@"---------- %@ ----------", key);
//        for (TDThemeConstant *constant in [self.tdd.constantArrayControllers[key] arrangedObjects]) {
//            NSLog(@"%@ - %@  - #%u (%@)", [constant displayName], [constant constantName], [constant identifier], [constant class]);
//        }
//        NSLog(@"-------------------------------");
//    }
}

- (IBAction)createSkeleton:(id)sender {
    [self customizeSchemaDefinitions];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Edit the assets" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now edit the images extracted, then come back and click the \"Export Appearance button\""];
    [alert runModal];
    
    [[NSWorkspace sharedWorkspace] openURL:[self.catalogURL URLByDeletingLastPathComponent]];
    
    [self.createSkeletonButton setKeyEquivalent:@""];
    [self.exportAppearanceButton setKeyEquivalent:@"\r"];
    [self.exportAppearanceButton setEnabled:YES];
}

- (IBAction)exportAppearance:(id)sender {
    [self customizeSchemaDefinitions];
    
    [self.tdd saveDocument:nil];
    
    self.distiller = [NSTask new];
    [self.distiller setLaunchPath:@"/System/Library/PrivateFrameworks/CoreThemeDefinition.framework/Versions/A/Resources/distill"];
    NSString *outputPath = [[self.catalogURL.path stringByDeletingPathExtension] stringByAppendingPathExtension:@"car"];
    [self.distiller setArguments:@[self.catalogURL.path, outputPath]];
    [self.distiller setStandardOutput:[NSPipe pipe]];
    [self.distiller launch];
    
    NSString *code = [NSString stringWithFormat:@"self.window.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@\"%@\" bundle:nil];",
                      [[outputPath lastPathComponent] stringByDeletingPathExtension]];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Use your custom appearance" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now you can use your custom appearance. Put the .car file in your app's resources and set It on your window or individual controls:\n\n%@", code];
    [alert runModal];
    
    [[NSWorkspace sharedWorkspace] selectFile:outputPath inFileViewerRootedAtPath:[outputPath stringByDeletingLastPathComponent]];
}


@end
