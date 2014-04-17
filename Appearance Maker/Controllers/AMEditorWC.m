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

@property (weak) IBOutlet NSPopUpButton *customFontPopUp;
@property (weak) IBOutlet NSTextField *customFontNameField;

@property (weak) IBOutlet NSButton *exportAppearanceButton;

/* Font customization metadata */
@property (strong) NSMutableDictionary *customFonts;

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
    [self.createSkeletonButton setEnabled:YES];
    [self.imageFormatPopUp setEnabled:YES];
    [self.customFontPopUp setEnabled:YES];
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
    [self.exportAppearanceButton setEnabled:YES];
}

- (IBAction)exportAppearance:(id)sender {
    [self customizeFonts];
    [self customizeSchemaDefinitions];
    
    // save the changes
    [self.tdd saveDocument:nil];
    
    // run distiller to transform the .uicatalog into a .car
    self.distiller = [NSTask new];
    [self.distiller setLaunchPath:@"/System/Library/PrivateFrameworks/CoreThemeDefinition.framework/Versions/A/Resources/distill"];
    NSString *outputPath = [[self.catalogURL.path stringByDeletingPathExtension] stringByAppendingPathExtension:@"car"];
    [self.distiller setArguments:@[self.catalogURL.path, outputPath]];
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

#pragma mark Font Selection

- (IBAction)customFontPopUpAction:(id)sender {
    // reset background color to white
    self.customFontNameField.backgroundColor = [NSColor whiteColor];
    
    // get font definition identifier which is the item's tag
    NSInteger identifier = self.customFontPopUp.selectedTag;
    
    // identifier 99 is the "Customize font..." placeholder
    if (identifier == 99) {
        self.customFontNameField.stringValue = @"";
        [self.customFontNameField setEnabled:NO];
        return;
    }
    
    // create dictionary if It doesn't exist yet
    if (!self.customFonts) self.customFonts = [[NSMutableDictionary alloc] init];
    
    // insert or change the font in the dictionary
    if ([self.customFonts objectForKey:@(identifier)]) {
        self.customFontNameField.stringValue = [self.customFonts objectForKey:@(identifier)];
    } else {
        self.customFontNameField.stringValue = @"Helvetica";
    }
    
    // enable the name field and move the focus to It
    [self.customFontNameField setEnabled:YES];
    [self.customFontNameField becomeFirstResponder];
}

- (IBAction)customFontNameFieldAction:(id)sender {
    // the tags are the font definition identifiers
    NSInteger identifier = self.customFontPopUp.selectedTag;
    
    // removes the spaces, font names in definitions should be camel case
    NSString *finalName = [[self.customFontNameField.stringValue componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    if (!finalName || [finalName isEqualToString:@""]) return;
    
    // save the custom font as the value and the identifier as the key
    [self.customFonts setObject:finalName forKey:@(identifier)];
    
    // make the background green to give the user some feedback
    self.customFontNameField.backgroundColor = [NSColor colorWithRed:0.830 green:1.000 blue:0.743 alpha:1.000];
    
    // enable the export button, in case the user wants to customize only the fonts...
    [self.exportAppearanceButton setEnabled:YES];
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
        if ([[[self.tdd elementWithIdentifier:i] displayName].lowercaseString rangeOfString:@"effect"].location != NSNotFound) continue;
        
        // this is what exports the artwork files
        [self.tdd customizeSchemaElementDefinition:[self.tdd schemaDefinitionWithElementID:i] usingArtworkFormat:[self artworkFormat] shouldReplaceExisting:NO error:nil];
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

/**
 Creates font definitions according to the fonts defined by
 the user and stored in self.customFonts
 */
- (void)customizeFonts
{
    for (NSNumber *identifier in self.customFonts) {
        // create font definition entity
        TDFontDefinition *fontDef = [self.tdd newObjectForEntity:@"FontDefinition"];
        // set the font name
        fontDef.postscriptName = self.customFonts[identifier];
        
        // create the selector
        TDMetafontSelector *selector = [self.tdd constantWithName:@"MetafontSelector" forIdentifier:[identifier integerValue]];
        fontDef.selector = selector;
        selector.definition = fontDef;
    }
}


@end
