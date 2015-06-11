//
//  AMDocumentBasedViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMDocumentBasedViewController.h"

#import "AMThemeDocument.h"

@interface AMDocumentBasedViewController ()

@end

@implementation AMDocumentBasedViewController

- (AMThemeDocument *)document
{
    if (![self.representedObject isKindOfClass:[AMThemeDocument class]]) return nil;
    
    return (AMThemeDocument *)self.representedObject;
}

@end
