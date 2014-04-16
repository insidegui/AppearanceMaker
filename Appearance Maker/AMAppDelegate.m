//
//  AMAppDelegate.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 16/04/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "AMAppDelegate.h"

#import "AMEditorWC.h"

@interface AMAppDelegate ()

@property (strong) AMEditorWC *editorWC;

@end

@implementation AMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.editorWC = [[AMEditorWC alloc] init];
    [self.editorWC showWindow:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
