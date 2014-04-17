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

/* controls */
@property (weak) IBOutlet NSButton *makeNewAppearanceButton;
@property (weak) IBOutlet NSPopUpButton *imageFormatPopUp;
@property (weak) IBOutlet NSButton *createSkeletonButton;
@property (weak) IBOutlet NSButton *exportAppearanceButton;

/* URL to the .uicatalog file */
@property (copy) NSURL *catalogURL;

/* the document */
@property (strong) CoreThemeDocument *tdd;

/* task to launch "distiller", the command line tool
 which turns the .uicatalog into a .car */
@property (strong) NSTask *distiller;

@end

@implementation AMEditorWC

#pragma mark Initialization

/**
 designated initializer
 */
- (id)init
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    // configure appearance
    self.window.backgroundColor = [NSColor whiteColor];
    [self.window setMovableByWindowBackground:YES];
    
    // a demonstration that this actually works :)
    self.window.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@"AMEditorAppearance" bundle:nil];
    
    // update UI
    [self.imageFormatPopUp setEnabled:NO];
    [self.createSkeletonButton setEnabled:NO];
    [self.exportAppearanceButton setEnabled:NO];
    
    [self.makeNewAppearanceButton setKeyEquivalent:@"\r"];
}

#pragma mark Actions

- (IBAction)newAppearance:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:@[@"uicatalog"]];
    [savePanel setPrompt:@"Save"];
    [savePanel setTitle:@"Save UI Catalog File"];
    
    // cancelled
    if (![savePanel runModal]) return;
    
    // save URL
    self.catalogURL = savePanel.URL;
    
    // configure the document
    NSError *error;
    self.tdd = [CoreThemeDocument createConfiguredDocumentAtURL:self.catalogURL error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return;
    }
    
    // update the UI
    [self.makeNewAppearanceButton setKeyEquivalent:@""];
    [self.createSkeletonButton setKeyEquivalent:@"\r"];
    [self.createSkeletonButton setEnabled:YES];
    [self.imageFormatPopUp setEnabled:YES];
}

/**
 Returns the artwork format selected in the UI (PSD or PNG)
 */
- (NSString *)artworkFormat
{
    return [[self.imageFormatPopUp selectedItem].title lowercaseString];
}

- (IBAction)createSkeleton:(id)sender {
    [self customizeSchemaDefinitions];
    
    // instruct the user
    NSAlert *alert = [NSAlert alertWithMessageText:@"Edit the assets" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now edit the images extracted, then come back and click the \"Export Appearance button\""];
    [alert runModal];
    
    // open the folder
    [[NSWorkspace sharedWorkspace] openURL:[self.catalogURL URLByDeletingLastPathComponent]];
    
    // update the UI
    [self.createSkeletonButton setKeyEquivalent:@""];
    [self.exportAppearanceButton setKeyEquivalent:@"\r"];
    [self.exportAppearanceButton setEnabled:YES];
}

- (IBAction)exportAppearance:(id)sender {
    [self customizeSchemaDefinitions];
    
    // save the changes
    [self.tdd saveDocument:nil];
    
    // run distiller to transform the .uicatalog into a .car
    self.distiller = [NSTask new];
    [self.distiller setLaunchPath:@"/System/Library/PrivateFrameworks/CoreThemeDefinition.framework/Versions/A/Resources/distill"];
    NSString *outputPath = [[self.catalogURL.path stringByDeletingPathExtension] stringByAppendingPathExtension:@"car"];
    [self.distiller setArguments:@[self.catalogURL.path, outputPath]];
    [self.distiller setStandardOutput:[NSPipe pipe]];
    [self.distiller launch];
    
    // create sample code
    NSString *code = [NSString stringWithFormat:@"self.window.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@\"%@\" bundle:nil];",
                      [[outputPath lastPathComponent] stringByDeletingPathExtension]];
    
    // instruct the user
    NSAlert *alert = [NSAlert alertWithMessageText:@"Use your custom appearance" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now you can use your custom appearance. Put the .car file in your app's resources and set It on your window or individual controls:\n\n%@", code];
    [alert runModal];
    
    // reveal the .car in Finder
    [[NSWorkspace sharedWorkspace] selectFile:outputPath inFileViewerRootedAtPath:[outputPath stringByDeletingLastPathComponent]];
}

#pragma mark Appearance Customization

/**
 Creates the "Artwork" folder and exports the PSDs,
 this needs to be called after the PSDs are edited to register the changes
 */
- (void)customizeSchemaDefinitions
{
    /* there is a better way of doing this,
     since I don't know exactly how many elements there are,
     I just guess a number (2000 in this case) and fetch everything within this range */
    for (int i = 0; i < 2000; i++) {
        if ([[[self.tdd elementWithIdentifier:i] displayName].lowercaseString rangeOfString:@"effect"].location != NSNotFound) {
            // "effects" are different
            [self.tdd customizeSchemaEffectDefinition:[self.tdd schemaDefinitionWithElementID:i] shouldReplaceExisting:NO error:nil];
        } else {
            // this is what exports the PSD
            [self.tdd customizeSchemaElementDefinition:[self.tdd schemaDefinitionWithElementID:i] usingArtworkFormat:[self artworkFormat] shouldReplaceExisting:NO error:nil];
        }
    }
    
    // the following is just a test, ignore for now...
    //
    //    for (NSString *key in self.tdd.constantArrayControllers.allKeys) {
    //        NSLog(@"---------- %@ ----------", key);
    //        for (TDThemeConstant *constant in [self.tdd.constantArrayControllers[key] arrangedObjects]) {
    //            NSLog(@"%@ - %@  - #%u (%@)", [constant displayName], [constant constantName], [constant identifier], [constant class]);
    //        }
    //        NSLog(@"-------------------------------");
    //    }
}


@end
