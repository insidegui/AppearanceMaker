//
//  AMColorsEditorViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMColorsEditorViewController.h"
#import "AMThemeDocument.h"
#import "AMSystemThemeStore.h"

@interface AMColorsEditorViewController ()

@property (weak) IBOutlet NSPopUpButton *colorsPopUp;

@property (nonatomic, strong) NSArray <TDColorName *> *colorNames;
@property (nonatomic, strong) TDColorName *selectedColorName;

@property (weak) IBOutlet NSColorWell *colorWell;
@property (weak) IBOutlet NSTextField *infoLabel;

@property (nonatomic, strong) TDColorDefinition *currentColorDefinition;

@end

@implementation AMColorsEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self loadColors];
}

- (void)loadColors
{
    NSArray *colors = [self.document allObjectsForEntity:@"ColorName" withSortDescriptors:self.document.defaultSortDescriptors];
    NSMutableArray *finalColors = [[NSMutableArray alloc] initWithCapacity:colors.count];
    for (TDColorName *colorName in colors) {
        if (![[AMSystemThemeStore defaultStore] hasPhysicalColorWithName:colorName.selector] && !colorName.colorDefinitions.count) continue;
        [finalColors addObject:colorName];
    }
    self.colorNames = [finalColors copy];
}

#pragma mark Color selection

- (void)setColorNames:(NSArray *)colorNames
{
    _colorNames = colorNames;
    
    [self populateColorsPopUp];
}

- (void)populateColorsPopUp
{
    [self.colorsPopUp removeAllItems];
    
    for (TDColorName *name in self.colorNames) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:name.displayName action:nil keyEquivalent:@""];
        item.representedObject = name;
        [self.colorsPopUp.menu addItem:item];
    }
    
    [self colorsPopUpAction:self.colorsPopUp];
}

- (IBAction)colorsPopUpAction:(id)sender
{
    self.selectedColorName = self.colorsPopUp.selectedItem.representedObject;
}

- (void)setSelectedColorName:(TDColorName *)selectedColorName
{
    _selectedColorName = selectedColorName;
    
    [self reflectColorSelectionChange];
}

- (void)reflectColorSelectionChange
{
    if (self.selectedColorName.colorDefinitions.count) {
        self.currentColorDefinition = self.selectedColorName.colorDefinitions.allObjects[0];
    } else {
        self.currentColorDefinition = [self.document newObjectForEntity:@"ColorDefinition"];
        self.currentColorDefinition.name = self.selectedColorName;
        self.currentColorDefinition.look = self.document.defaultLook;
        self.currentColorDefinition.dateOfLastChange = [NSDate date];
        
        self.currentColorDefinition.colorStatus = [self.document constantWithName:@"ColorStatus" forIdentifier:1];
    }
    
    [self updateColorWell];
}

- (void)updateColorWell
{
    if (self.currentColorDefinition.physicalColor && ![self.currentColorDefinition.physicalColor isEqualTo:@0]) {
        self.colorWell.color = [AMSystemThemeStore colorWithPhysicalColor:self.currentColorDefinition.physicalColor];
    } else {
        colordef_t colorDef;
        if ([[AMSystemThemeStore defaultStore] getPhysicalColor:&colorDef withName:self.selectedColorName.selector]) {
            self.colorWell.color = [AMSystemThemeStore colorWithColorDef:colorDef];
        }
    }
}

- (IBAction)colorWellAction:(id)sender
{
    self.currentColorDefinition.physicalColor = [AMSystemThemeStore physicalColorWithColor:self.colorWell.color];
}

@end
