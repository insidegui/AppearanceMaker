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
#import "AMEditorAppearance.h"

@interface AMElementsEditorViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readonly) AMThemeDocument *document;

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

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.view.appearance = [AMEditorAppearance appearance];
}

- (AMThemeDocument *)document
{
    return (AMThemeDocument *)self.representedObject;
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
        [self.categoriesPopUp addItemWithTitle:category.displayName];
    }
    
    [self categoriesPopUpAction:self.categoriesPopUp];
}

- (IBAction)categoriesPopUpAction:(id)sender
{
    self.selectedCategory = self.categories[self.categoriesPopUp.indexOfSelectedItem];
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
    NSError *error;
    if ([self.document customizeSchemaElementDefinition:self.selectedDefinition usingArtworkFormat:@"psd" shouldReplaceExisting:NO error:&error]) {
        [[NSWorkspace sharedWorkspace] selectFile:self.document.themeBitSourceURL.path inFileViewerRootedAtPath:nil];
    } else {
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.document.windowForSheet completionHandler:nil];
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
