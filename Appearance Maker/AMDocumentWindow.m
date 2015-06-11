//
//  AMDocumentWindow.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMDocumentWindow.h"

@interface AMDocumentWindow () <NSToolbarDelegate>

@property (nonatomic, readonly) NSTabViewController *tabVC;
@property (nonatomic, strong) NSSegmentedControl *tabNavSegmentedControl;

@end

@implementation AMDocumentWindow
{
    void *_childViewControllersObservationContext;
    void *_selectedTabObservationContext;
}

- (nonnull instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    [self.contentView setWantsLayer:YES];
    self.titleVisibility = NSWindowTitleHidden;

    _childViewControllersObservationContext = &_childViewControllersObservationContext;
    _selectedTabObservationContext = &_selectedTabObservationContext;
    
    return self;
}

- (void)setContentViewController:(NSViewController * __nullable)contentViewController
{
    [super setContentViewController:contentViewController];
    
    if ([contentViewController isKindOfClass:[NSTabViewController class]]) {
        [self _am_setupTabNavigation];
    }
}

- (void)_am_setupTabNavigation
{
    [self.contentViewController addObserver:self
                                 forKeyPath:@"childViewControllers"
                                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                    context:_childViewControllersObservationContext];
    [self.contentViewController addObserver:self
                                 forKeyPath:@"selectedTabViewItemIndex"
                                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                    context:_selectedTabObservationContext];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __nonnull note) {
        [self.tabVC removeObserver:self forKeyPath:@"childViewControllers"];
        [self.tabVC removeObserver:self forKeyPath:@"selectedTabViewItemIndex"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:self];
    }];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context
{
    if (context == _childViewControllersObservationContext) {
        [self _am_setupTabs];
    } else if (context == _selectedTabObservationContext) {
        [self _am_reflectTabSelectionChange];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#define kSegmentedControlItemIdentifier @"SegmentedControl"

- (void)_am_setupTabs
{
    self.toolbar = [self _am_toolbarWithTabItems:self.tabVC.tabViewItems];
}

- (NSToolbar *)_am_toolbarWithTabItems:(NSArray <NSTabViewItem *> *)items
{
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"TabNavToolbar"];
    toolbar.delegate = self;

    return toolbar;
}

- (nullable NSToolbarItem *)toolbar:(nonnull NSToolbar *)toolbar itemForItemIdentifier:(nonnull NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    if (![itemIdentifier isEqualToString:kSegmentedControlItemIdentifier]) return nil;

    self.tabNavSegmentedControl = [[NSSegmentedControl alloc] initWithFrame:NSZeroRect];
    self.tabNavSegmentedControl.segmentCount = self.tabVC.tabViewItems.count;
    for (NSTabViewItem *item in self.tabVC.tabViewItems) {
        NSInteger idx = [self.tabVC.tabViewItems indexOfObject:item];
        [self.tabNavSegmentedControl setLabel:item.label forSegment:idx];
        if (self.tabVC.selectedTabViewItemIndex == idx) [self.tabNavSegmentedControl setSelectedSegment:idx];
    }
    [self.tabNavSegmentedControl setTarget:self];
    [self.tabNavSegmentedControl setAction:@selector(_am_tabBarNavSegmentedControlAction:)];
    [self.tabNavSegmentedControl sizeToFit];
    
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:kSegmentedControlItemIdentifier];

    item.view = self.tabNavSegmentedControl;
    
    return item;
}

- (NSArray<NSString *> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier, kSegmentedControlItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier];
}

- (NSArray<NSString *> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return @[kSegmentedControlItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier];
}

- (void)_am_tabBarNavSegmentedControlAction:(NSSegmentedControl *)control
{
    [self.tabVC setSelectedTabViewItemIndex:control.selectedSegment];
}

- (void)_am_reflectTabSelectionChange
{
    [self.tabNavSegmentedControl setSelectedSegment:self.tabVC.selectedTabViewItemIndex];
}

- (NSTabViewController *)tabVC
{
    return (NSTabViewController *)self.contentViewController;
}

@end