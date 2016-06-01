//
//  AMElementsEditorViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMElementsEditorViewController.h"

#import "AMThemeDocument.h"
#import "AMPartTableCellView.h"

#import "AMEffectEditorWindowController.h"
#import "PSDPreview.h"

@interface AMElementsEditorViewController () <NSTableViewDataSource, NSTableViewDelegate, TDAssetManagementDelegate>

@property (weak) IBOutlet NSVisualEffectView *topBarView;
@property (weak) IBOutlet NSVisualEffectView *bottomBarView;

@property (weak) IBOutlet NSPopUpButton *categoriesPopUp;
@property (weak) IBOutlet NSPopUpButton *elementsPopUp;

@property (strong) NSArray <TDSchemaCategory *> *categories;
@property (strong) NSArray <__kindof TDSchemaDefinition *> *sortedDefinitions;

@property (nonatomic, strong) TDSchemaCategory *selectedCategory;
@property (nonatomic, strong) TDSchemaDefinition *selectedDefinition;
@property (nonatomic, strong) TDSchemaPartDefinition *selectedPart;

@property (weak) IBOutlet NSButton *customizeButton;

@property (strong) AMEffectEditorWindowController *effectEditorWindowController;

@property (weak) IBOutlet NSTextField *selectedElementLabel;
@property (weak) IBOutlet NSStackView *previewPartControlsContainerView;
@property (weak) IBOutlet NSPopUpButton *partsPopUp;
@property (weak) IBOutlet NSStackView *previewContainerView;
@property (weak) IBOutlet NSImageView *systemAppearanceImageView;
@property (weak) IBOutlet NSImageView *customizedAppearanceImageView;
@property (weak) IBOutlet NSStackView *customizedAppearanceContainerView;

@end

@implementation AMElementsEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedElementLabel.stringValue = @"(Select an element above)";
    self.previewContainerView.hidden = YES;
    self.previewPartControlsContainerView.hidden = YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    self.document.assetManagementDelegate = self;
}

- (void)setRepresentedObject:(id __nullable)representedObject
{
    [super setRepresentedObject:representedObject];
    
    [self populateCategories];
}

#pragma mark Category and Element selection

- (void)populateCategories
{
    [self.categoriesPopUp removeAllItems];
    
    self.categories = [self.document allObjectsForEntity:@"SchemaCategory" withSortDescriptors:self.document.defaultSortDescriptors];
    for (TDSchemaCategory *category in self.categories) {
        // materials and effects are handled in other view controllers
        if ([category.displayName isEqualToString:@"Materials"] ||
            [category.displayName isEqualToString:@"Effects"]) continue;
        
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:category.displayName action:nil keyEquivalent:@""];
        item.representedObject = category;
        [self.categoriesPopUp.menu addItem:item];
    }
    
    [self categoriesPopUpAction:self.categoriesPopUp];
}

- (IBAction)categoriesPopUpAction:(id)sender
{
    self.selectedCategory = self.categoriesPopUp.selectedItem.representedObject;
}

- (IBAction)elementsPopUpAction:(id)sender
{
    if (self.elementsPopUp.indexOfSelectedItem < 0) return;
    
    self.selectedDefinition = self.sortedDefinitions[self.elementsPopUp.indexOfSelectedItem];
}

- (void)setSelectedCategory:(TDSchemaCategory *)selectedCategory
{
    _selectedCategory = selectedCategory;
    
    [self reflectCategorySelectionChange];
}

- (void)setSelectedDefinition:(TDSchemaDefinition *)selectedDefinition
{
    _selectedDefinition = selectedDefinition;
    
    [self reflectDefinitionSelectionChange];
}

- (void)setSelectedPart:(TDSchemaPartDefinition *)selectedPart
{
    _selectedPart = selectedPart;
    
    [self reflectPartSelectionChange];
}

- (NSString *)titleForDefinition:(TDSchemaDefinition *)definition
{
    NSString *title = definition.displayName;
    if (!definition.published) title = [title stringByAppendingString:@" (Unpublished)"];
    if ([self.document customizationExistsForSchemaDefinition:definition]) title = [title stringByAppendingString:@" (Customized)"];
    
    return title;
}

- (void)reflectCategorySelectionChange
{
    TDSchemaDefinition *previouslySelectedDefinition = self.elementsPopUp.selectedItem.representedObject;
    
    [self.elementsPopUp removeAllItems];
    
    self.sortedDefinitions = [self.selectedCategory.elements sortedArrayUsingDescriptors:self.document.defaultSortDescriptors];
    for (TDSchemaDefinition *definition in self.sortedDefinitions) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[self titleForDefinition:definition] action:nil keyEquivalent:@""];
        item.representedObject = definition;
        
        [self.elementsPopUp.menu addItem:item];
    }
    
    if (!self.elementsPopUp.itemArray.count) {
        [self.elementsPopUp addItemWithTitle:@"No Elements"];
        self.elementsPopUp.enabled = NO;
    } else {
        self.elementsPopUp.enabled = YES;
        
        if (previouslySelectedDefinition) [self.elementsPopUp selectItemWithTitle:[self titleForDefinition:previouslySelectedDefinition]];
        
        [self elementsPopUpAction:self.elementsPopUp];
    }
}

- (void)reflectDefinitionSelectionChange
{
    if (self.selectedDefinition == nil) {
        self.selectedElementLabel.stringValue = @"(Select an element above)";
    } else {
        self.selectedElementLabel.stringValue = self.selectedDefinition.displayName;
    }
    
    [self.selectedElementLabel sizeToFit];
    
    self.previewPartControlsContainerView.hidden = (self.selectedDefinition == nil);
    self.previewContainerView.hidden = (self.selectedDefinition == nil);
    self.customizeButton.enabled = (self.selectedDefinition != nil);
    
    [self populatePartsPopUp];
}

- (void)populatePartsPopUp
{
    [self.partsPopUp removeAllItems];
    
    for (TDSchemaPartDefinition *part in self.selectedDefinition.parts) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:part.name action:nil keyEquivalent:@""];
        item.representedObject = part;
        [self.partsPopUp.menu addItem:item];
    }
    
    [self partsPopUpAction:self.partsPopUp];
}

#pragma mark Appearance Customization

- (IBAction)customizeSelectedDefinition:(id)sender
{
    if ([self.selectedDefinition isKindOfClass:[TDSchemaEffectDefinition class]]) {
        [self customizeEffectDefinition:(TDSchemaEffectDefinition *)self.selectedDefinition];
    } else {
        [self customizePartDefinition:self.selectedPart];
    }
}

- (void)customizeEffectDefinition:(TDSchemaEffectDefinition *)definition
{
    if (!self.effectEditorWindowController) {
        self.effectEditorWindowController = [AMEffectEditorWindowController effectEditorWindowControllerWithEffectDefinition:definition document:self.document];
    } else {
        self.effectEditorWindowController.document = self.document;
        self.effectEditorWindowController.effectDefinition = definition;
    }
    
    [self.effectEditorWindowController showWindow:self];
}

- (void)customizePartDefinition:(TDSchemaPartDefinition *)part
{
    NSError *error;
    if (![self.document customizeSchemaPartDefinition:part usingArtworkFormat:@"psd" nameElement:nil shouldReplaceExisting:NO error:&error]) {
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.document.windowForSheet completionHandler:nil];
    }
    
    [self reflectPartSelectionChange];
}

//- (void)customizeElementDefinition:(TDSchemaDefinition *)definition
//{
//    NSError *error;
//    if (![self.document customizeSchemaElementDefinition:self.selectedDefinition usingArtworkFormat:@"psd" shouldReplaceExisting:NO error:&error]) {
//        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.document.windowForSheet completionHandler:nil];
//    }
//    
//    [self reflectCategorySelectionChange];
//}

- (void)didCreateAsset:(__kindof TDAsset *)asset atURL:(NSURL *)URL
{
    static BOOL coalescing = NO;
    if (coalescing) return;
    
    coalescing = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        coalescing = NO;
    });
    
    [[NSWorkspace sharedWorkspace] selectFile:URL.path inFileViewerRootedAtPath:URL.path.stringByDeletingLastPathComponent];
}

#pragma mark Element display

- (IBAction)partsPopUpAction:(id)sender
{
    self.selectedPart = self.partsPopUp.selectedItem.representedObject;
}

- (TDPhotoshopElementProduction *)productionForPreviewingPart:(TDSchemaPartDefinition *)part
{
    NSString *renditionName = [[part bestPreviewRendition] name];
    
    for (TDPhotoshopElementProduction *production in part.productions) {
        if ([production.comment containsString:renditionName]) {
            return production;
        }
    }
    
    return [[part.productions allObjects] firstObject];
}

- (void)reflectPartSelectionChange
{
    self.systemAppearanceImageView.image = self.selectedPart.previewImage;
    
    if (self.selectedPart.productions.count > 0) {
        [self.customizedAppearanceContainerView setHidden:NO];
        
        TDPhotoshopElementProduction *previewProduction = [self productionForPreviewingPart:self.selectedPart];
        NSImage *previewImage = [[NSImage alloc] initWithContentsOfURL:[previewProduction.asset fileURLWithDocument:self.document]];
        self.customizedAppearanceImageView.image = previewImage;
        self.customizeButton.title = @"Edit…";
    } else {
        [self.customizedAppearanceContainerView setHidden:YES];
        self.customizeButton.title = @"Customize";
    }
}

#pragma mark Parts Table View

- (NSInteger)numberOfRowsInTableView:(nonnull NSTableView *)tableView
{
    return self.selectedDefinition.parts.count;
}

- (nullable NSView *)tableView:(nonnull NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    AMPartTableCellView *cell = [tableView makeViewWithIdentifier:@"PartCell" owner:tableView];
    
    cell.part = self.selectedDefinition.parts.allObjects[row];
    
    return cell;
}

- (CGFloat)tableView:(nonnull NSTableView *)tableView heightOfRow:(NSInteger)row
{
    TDSchemaPartDefinition *part = self.selectedDefinition.parts.allObjects[row];
    
    return part.previewImage.size.height+16;
}

@end
