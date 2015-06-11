//
//  AMPartTableCellView.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 10/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMPartTableCellView.h"

@implementation AMPartTableCellView

- (void)setPart:(TDSchemaPartDefinition * __nullable)part
{
    _part = part;
    
    self.previewImageView.image = _part.previewImage;
    self.textField.stringValue = _part.displayName;
}

@end
