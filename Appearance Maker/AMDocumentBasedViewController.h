//
//  AMDocumentBasedViewController.h
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMThemeDocument;

@interface AMDocumentBasedViewController : NSViewController

@property (nonatomic, readonly) AMThemeDocument *document;

@end
