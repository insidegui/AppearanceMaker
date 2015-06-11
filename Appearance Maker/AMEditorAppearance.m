//
//  AMEditorAppearance.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMEditorAppearance.h"

@interface AMEditorAppearance ()

@property (strong) NSAppearance *appearance;

@end

@implementation AMEditorAppearance

+ (NSAppearance *)appearance
{
    return [AMEditorAppearance _sharedInstance].appearance;
}

+ (AMEditorAppearance *)_sharedInstance
{
    static AMEditorAppearance *_shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[AMEditorAppearance alloc] init];
    });
    
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    
    self.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@"AMEditorAppearance" bundle:nil];
    
    return self;
}

@end
