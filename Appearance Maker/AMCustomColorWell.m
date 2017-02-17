//
//  AMCustomColorWell.m
//  Appearance Maker
//
//  Created by leo on 2017/2/17.
//  Copyright © 2017年 Guilherme Rambo. All rights reserved.
//

#import "AMCustomColorWell.h"

@implementation AMCustomColorWell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)activate:(BOOL)exclusive
{
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [super activate:exclusive];
}

- (void)deactivate
{
    [super deactivate];
    [[NSColorPanel sharedColorPanel] setShowsAlpha:NO];
}

@end
