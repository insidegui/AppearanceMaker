//
//  ViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMEditorViewController.h"

@implementation AMEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabStyle = NSTabViewControllerTabStyleUnspecified;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(setRepresentedObject:) withObject:representedObject];
}

- (void)addChildViewController:(nonnull NSViewController *)childViewController
{
    [super addChildViewController:childViewController];
    [childViewController setRepresentedObject:self.representedObject];
}

@end
