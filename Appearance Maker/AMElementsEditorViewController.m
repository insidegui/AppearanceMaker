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

@interface AMElementsEditorViewController () <NSTableViewDataSource, NSTableViewDelegate, TDAssetManagementDelegate>

@property (weak) IBOutlet NSVisualEffectView *topBarView;
@property (weak) IBOutlet NSVisualEffectView *bottomBarView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;

@property (weak) IBOutlet NSPopUpButton *categoriesPopUp;
@property (weak) IBOutlet NSPopUpButton *elementsPopUp;

@property (strong) NSArray <TDSchemaCategory *> *categories;
@property (strong) NSArray <__kindof TDSchemaDefinition *> *sortedDefinitions;

@property (nonatomic, strong) TDSchemaCategory *selectedCategory;
@property (nonatomic, strong) TDSchemaDefinition *selectedDefinition;

@property (weak) IBOutlet NSButton *customizeButton;

@property (strong) AMEffectEditorWindowController *effectEditorWindowController;

@end

@implementation AMElementsEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.automaticallyAdjustsContentInsets = NO;
    self.scrollView.contentInsets = NSEdgeInsetsMake(NSHeight(self.topBarView.frame), 0, NSHeight(self.bottomBarView.frame), 0);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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

- (void)reflectCategorySelectionChange
{
    [self.elementsPopUp removeAllItems];
    
    self.sortedDefinitions = [self.selectedCategory.elements sortedArrayUsingDescriptors:self.document.defaultSortDescriptors];
    for (TDSchemaDefinition *definition in self.sortedDefinitions) {
        NSString *title = definition.displayName;
        if (!definition.published) title = [title stringByAppendingString:@" (Unpublished)"];
        
        [self.elementsPopUp addItemWithTitle:title];
    }
    
    if (!self.elementsPopUp.itemArray.count) {
        [self.elementsPopUp addItemWithTitle:@"No Elements"];
        self.elementsPopUp.enabled = NO;
    } else {
        self.elementsPopUp.enabled = YES;
        
        [self elementsPopUpAction:self.elementsPopUp];
    }
}

- (void)reflectDefinitionSelectionChange
{
    [self.tableView reloadData];
    self.customizeButton.enabled = (self.selectedDefinition != nil);
}

#pragma mark Appearance Customization

- (IBAction)customizeSelectedDefinition:(id)sender
{
    if ([self.selectedDefinition isKindOfClass:[TDSchemaEffectDefinition class]]) {
        [self customizeEffectDefinition:(TDSchemaEffectDefinition *)self.selectedDefinition];
    } else {
        [self customizeElementDefinition:self.selectedDefinition];
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

- (void)customizeElementDefinition:(TDSchemaDefinition *)definition
{
    NSError *error;
    if (![self.document customizeSchemaElementDefinition:self.selectedDefinition usingArtworkFormat:@"psd" shouldReplaceExisting:NO error:&error]) {
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.document.windowForSheet completionHandler:nil];
    }
}

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
