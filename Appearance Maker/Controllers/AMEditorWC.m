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

#define kUserKnowsTheProcessKey @"KnowsTheDrill"

@interface AMEditorWC ()

/* controls */

@property (weak) IBOutlet NSButton *makeNewAppearanceButton;

@property (weak) IBOutlet NSPopUpButton *imageFormatPopUp;
@property (weak) IBOutlet NSButton *createSkeletonButton;

@property (weak) IBOutlet NSPopUpButton *customFontPopUp;
@property (weak) IBOutlet NSTextField *customFontNameField;

@property (weak) IBOutlet NSPopUpButton *customColorPopUp;
@property (weak) IBOutlet NSColorWell *customColorWell;


@property (weak) IBOutlet NSButton *exportAppearanceButton;

/* Font customization metadata */
@property (strong) NSMutableDictionary *customFonts;

/* Color customization metadata */
@property (strong) NSMutableDictionary *customColors;

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
    [savePanel setPrompt:@"Select"];
    [savePanel setTitle:@"Select or save UI Catalog File"];
    
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
    
    [self populateColorPopUp];
    [self.customColorPopUp setEnabled:YES];
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUserKnowsTheProcessKey]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Edit the assets" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now edit the images extracted, then come back and click the \"Export Appearance button\""];
        [alert runModal];
    }
    
    // open the folder
    [[NSWorkspace sharedWorkspace] openURL:[self.catalogURL URLByDeletingLastPathComponent]];
    
    // update the UI
    [self.exportAppearanceButton setEnabled:YES];
}

- (IBAction)exportAppearance:(id)sender {
    [self customizeFonts];
    [self customizeColors];
    [self customizeSchemaDefinitions];
    
    // save the changes
    [self.tdd saveDocument:nil];
    
    // run distiller to transform the .uicatalog into a .car
    self.distiller = [NSTask new];
    [self.distiller setLaunchPath:@"/System/Library/PrivateFrameworks/CoreThemeDefinition.framework/Versions/A/Resources/distill"];
    NSString *outputPath = [[self.catalogURL.path stringByDeletingPathExtension] stringByAppendingPathExtension:@"car"];
    [self.distiller setArguments:@[self.catalogURL.path, outputPath, @"LogWarningsAndErrors"]];
    [self.distiller launch];
    
    // create sample code
    NSString *code = [NSString stringWithFormat:@"self.window.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@\"%@\" bundle:nil];",
                      [[outputPath lastPathComponent] stringByDeletingPathExtension]];
    
    // instruct the user
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUserKnowsTheProcessKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserKnowsTheProcessKey];
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Use your custom appearance" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now you can use your custom appearance. Put the .car file in your app's resources and set It on your window or individual controls:\n\n%@", code];
        [alert runModal];
    }
    
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
    if (!self.customFonts) self.customFonts = [NSMutableDictionary new];
    
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

#pragma mark Color Selection

- (void)populateColorPopUp
{
    NSArray *colors = [self.tdd allObjectsForEntity:@"ColorName" withSortDescriptors:nil];
    for (TDColorName *color in colors) {
        [self.customColorPopUp addItemWithTitle:color.displayName];
    }
}

- (IBAction)customColorPopUpAction:(id)sender {
    // identifier 99 is the "Customize Color..." placeholder
    if (self.customColorPopUp.selectedTag == 99) {
        [self.customColorWell setEnabled:NO];
        return;
    }
    
    // create dictionary if It doesn't exist yet
    if (!self.customColors) self.customColors = [NSMutableDictionary new];
    
    if ([self.customColors objectForKey:self.customColorPopUp.selectedItem.title]) {
        // set the color of the color well to the custom color
        [self.customColorWell setColor:[self.customColors objectForKey:self.customColorPopUp.selectedItem.title]];
    } else {
        // set the color of the color well to the default color
        NSString *selectorName = [self colorNameWithDisplayName:self.customColorPopUp.selectedItem.title].selector;
        SEL selector = NSSelectorFromString(selectorName);
        NSColor *defaultColor = [NSClassFromString(@"NSColor") performSelector:selector];
        [self.customColorWell setColor:defaultColor];
    }
    
    [self.customColorWell setEnabled:YES];
}

- (IBAction)customColorWellAction:(id)sender {
    // save custom color
    [self.customColors setObject:self.customColorWell.color forKey:self.customColorPopUp.selectedItem.title];
    
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
        if ([[[[self.tdd elementWithIdentifier:i] displayName] lowercaseString] rangeOfString:@"effect"].location != NSNotFound) continue;
        
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
    if (!self.customFonts) return;
    
    // delete old entities
    [self.tdd deleteObjects:[self.tdd allObjectsForEntity:@"FontDefinition" withSortDescriptors:nil]];
    
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

- (void)customizeColors
{
    if (!self.customColors) return;
    
    // delete old entities
    [self.tdd deleteObjects:[self.tdd allObjectsForEntity:@"ColorDefinition" withSortDescriptors:nil]];
    
    for (NSString *displayName in self.customColors.allKeys) {
        // create color name
        TDColorName *name = [self colorNameWithDisplayName:displayName];
        
        // get NSColor associated with this entry
        NSColor *ns_color = self.customColors[displayName];
        
        // convert to physical color
        NSNumber *physicalColor = [self physicalColorWithNSColor:ns_color];
        
        // perform customization
        [self customizeColor:name withPhysicalColor:physicalColor];
    }
}

- (void)customizeColor:(TDColorName *)colorName withPhysicalColor:(NSNumber *)physicalColor
{
    // create a color definition for the specified color name in every look available
    for (TDThemeLook *look in [self.tdd.constantArrayControllers[@"ThemeLook"] arrangedObjects]) {
        TDColorDefinition *colorDef = [self.tdd newObjectForEntity:@"ColorDefinition"];
        colorDef.name = colorName;
        colorDef.physicalColor = physicalColor;
        colorDef.look = look;
        colorDef.dateOfLastChange = [NSDate date];
        // set color status to "done"
        colorDef.colorStatus = [self.tdd constantWithName:@"ColorStatus" forIdentifier:1];
    }
}

/**
 Returns the instance of TDColorName with the specified displayName
 */
- (TDColorName *)colorNameWithDisplayName:(NSString *)displayName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayName = %@", displayName];
    NSArray *filtered = [[self.tdd allObjectsForEntity:@"ColorName" withSortDescriptors:nil] filteredArrayUsingPredicate:predicate];
    
    return [filtered firstObject];
}

/**
 Converts an instance of NSColor to a physical color
 */
- (NSNumber *)physicalColorWithNSColor:(NSColor *)color
{
    return [self.tdd physicalColorWithRed:color.redComponent*255 green:color.greenComponent*255 blue:color.blueComponent*255 alpha:color.alphaComponent*255];
}

@end
