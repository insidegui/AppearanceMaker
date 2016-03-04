//
//  AMMaterialsEditorViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 03/03/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

#import "AMMaterialsEditorViewController.h"

#import "AMThemeDocument.h"
#import "TDMicaAsset.h"

@interface AMMaterialsEditorViewController () <NSTableViewDataSource, NSTableViewDelegate, TDAssetManagementDelegate>

@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSVisualEffectView *bottomBar;
@property (weak) IBOutlet NSButton *customizeButton;

@property (nonatomic, copy) NSArray <TDSchemaMaterialDefinition *> *materialDefinitions;

@end

@implementation AMMaterialsEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.automaticallyAdjustsContentInsets = NO;
    self.scrollView.contentInsets = NSEdgeInsetsMake(0, 0, NSHeight(self.bottomBar.bounds), 0);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    self.document.assetManagementDelegate = self;
    
    [self loadMaterialDefinitions];
}

- (void)loadMaterialDefinitions
{
    TDSchemaCategory *category = [self.document objectsForEntity:@"SchemaCategory" withPredicate:[NSPredicate predicateWithFormat:@"displayName = \"Materials\""] sortDescriptors:self.document.defaultSortDescriptors].firstObject;
    self.materialDefinitions = category.elements.allObjects;
    [self.tableView reloadData];
}

- (IBAction)customizeSelectedMaterial:(id)sender
{
    NSError *error;
    if (![self.document customizeSchemaMaterialDefinition:self.materialDefinitions[self.tableView.selectedRow] shouldReplaceExisting:NO error:&error]) {
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.document.windowForSheet completionHandler:nil];
    }
}

- (void)didCreateAsset:(__kindof TDAsset *)asset atURL:(NSURL *)URL
{
    if (![asset isKindOfClass:[TDMicaAsset class]]) return;
    
    // TODO: Open material editor (material editor still needs to be created 😅)
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.materialDefinitions.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"materialCell" owner:tableView];
    
    cellView.textField.stringValue = self.materialDefinitions[row].displayName;
    
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    self.customizeButton.enabled = (self.tableView.selectedRowIndexes.count > 0);
}

@end
