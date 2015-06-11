//
//  AMColorsEditorViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMColorsEditorViewController.h"
#import "AMThemeDocument.h"

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
    
    [self loadLooks];
}

- (void)loadLooks
{
    self.colorNames = [self.document allObjectsForEntity:@"ColorName" withSortDescriptors:self.document.defaultSortDescriptors];
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
        [self.colorsPopUp addItemWithTitle:name.displayName];
    }
    
    [self colorsPopUpAction:self.colorsPopUp];
}

- (IBAction)colorsPopUpAction:(id)sender
{
    self.selectedColorName = self.colorNames[self.colorsPopUp.indexOfSelectedItem];
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
        if ([NSColor respondsToSelector:NSSelectorFromString(self.selectedColorName.selector)]) {
            self.colorWell.color = [NSColor performSelector:NSSelectorFromString(self.selectedColorName.selector)];
            [self colorWellAction:self.colorWell];
        }
    }
}

- (IBAction)colorWellAction:(id)sender
{
    // TODO: update selected color definition
}

#pragma mark Color conversion

- (__nullable NSNumber *)physicalColorWithNSColor:(NSColor *)color
{
    return [self physicalColorWithRed:color.redComponent*255 green:color.greenComponent*255 blue:color.blueComponent*255 alpha:color.alphaComponent*255];
}

- (NSNumber *)physicalColorWithRed:(unsigned int)red green:(unsigned int)green blue:(unsigned int)blue alpha:(unsigned int)alpha
{
    unsigned int tmp1 = green << 0x8 & 0xffff;
    tmp1 = tmp1 | (red << 0x10 & 0xff0000);
    unsigned int tmp2 = (blue & 0xff) | tmp1;
    unsigned int output = (tmp2 | alpha << 0x18);
    
    return @(output);
}

@end
