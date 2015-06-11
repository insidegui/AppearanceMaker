//
//  AMSeparatorView.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMSeparatorView.h"

@implementation AMSeparatorView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.color) {
        [self.color setFill];
    } else {
        [[NSColor tertiaryLabelColor] setFill];
    }
    
    NSRectFill(dirtyRect);
}

- (void)setColor:(NSColor *)color
{
    _color = color;
    
    [self setNeedsDisplay:YES];
}

@end
