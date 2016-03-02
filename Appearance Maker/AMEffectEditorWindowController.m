//
//  AMEffectEditorWindowController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 02/03/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

#import "AMEffectEditorWindowController.h"

#import "TDEffectRenditionSpec.h"
#import "TDEffectComponent.h"
#import "TDEffectParameterValue.h"
#import "TDEffectParameterType.h"
#import "TDEffectType.h"

#import "AMSystemThemeStore.h"

#import "AMFlippedClipView.h"

#define kViewPadding 8.0

#define kCUIEffectParameterOpacity @"CUIEffectParameterOpacity"
#define kCUIEffectParameterOpacity2 @"CUIEffectParameterOpacity2"
#define kCUIEffectParameterColor1 @"CUIEffectParameterColor1"
#define kCUIEffectParameterColor2 @"CUIEffectParameterColor2"
#define kCUIEffectParameterBlurSize @"CUIEffectParameterBlurSize"
#define kCUIEffectParameterOffset @"CUIEffectParameterOffset"
#define kCUIEffectParameterSoftenSize @"CUIEffectParameterSoftenSize"
#define kCUIEffectParameterBlendMode @"CUIEffectParameterBlendMode"
#define kCUIEffectParameterSpread @"CUIEffectParameterSpread"
#define kCUIEffectParameterAngle @"CUIEffectParameterAngle"

typedef NS_ENUM(NSUInteger) {
    AMEffectParameterControlTypeUnkown,
    AMEffectParameterControlTypeTextField,
    AMEffectParameterControlTypeOpacitySlider,
    AMEffectParameterControlTypeAngleKnob,
    AMEffectParameterControlTypeColorWell,
    AMEffectParameterControlTypeBlendModePopUp
} AMEffectParameterControlType;

AMEffectParameterControlType _AMControlTypeForEffectParameter(TDEffectParameterValue *parameter) {
    NSString *name = parameter.parameterType.constantName;
    
    if ([name isEqualToString:kCUIEffectParameterOpacity] ||
        [name isEqualToString:kCUIEffectParameterOpacity2]) {
        return AMEffectParameterControlTypeOpacitySlider;
    } else if ([name isEqualToString:kCUIEffectParameterColor1] ||
               [name isEqualToString:kCUIEffectParameterColor2]) {
        return AMEffectParameterControlTypeColorWell;
    } else if ([name isEqualToString:kCUIEffectParameterBlurSize] ||
               [name isEqualToString:kCUIEffectParameterOffset] ||
               [name isEqualToString:kCUIEffectParameterSoftenSize] ||
               [name isEqualToString:kCUIEffectParameterSpread]) {
        return AMEffectParameterControlTypeTextField;
    } else if ([name isEqualToString:kCUIEffectParameterAngle]) {
        return AMEffectParameterControlTypeAngleKnob;
    } else if ([name isEqualToString:kCUIEffectParameterBlendMode]) {
        return AMEffectParameterControlTypeBlendModePopUp;
    }
    
    return AMEffectParameterControlTypeUnkown;
}

@interface AMEffectEditorWindowController ()

@property (nonatomic, readonly) AMThemeDocument *themeDocument;

@property (nonatomic, strong) NSMutableArray <TDEffectStyleProduction *> *productions;

@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSStackView *stackView;

@end

@implementation AMEffectEditorWindowController

+ (AMEffectEditorWindowController *)effectEditorWindowControllerWithEffectDefinition:(TDSchemaEffectDefinition *)effectDefinition document:(AMThemeDocument *)document
{
    AMEffectEditorWindowController *controller = [[AMEffectEditorWindowController alloc] initWithWindowNibName:NSStringFromClass([self class])];
    
    controller.document = document;
    controller.effectDefinition = effectDefinition;
    
    return controller;
}

- (AMThemeDocument *)themeDocument
{
    return (AMThemeDocument *)self.document;
}

- (NSMutableArray<TDEffectStyleProduction *> *)productions
{
    if (!_productions) _productions = [NSMutableArray new];
    
    return _productions;
}

- (void)setEffectDefinition:(TDSchemaEffectDefinition *)effectDefinition
{
    _effectDefinition = effectDefinition;
    
    [self _configureWithCurrentEffectDefinition];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.contentView.wantsLayer = YES;
    
    [self _createStackView];
    
#ifdef DEBUG
    if ([[NSBundle bundleWithPath:@"/Library/Frameworks/FScript.framework"] load]) {
        [NSClassFromString(@"FScriptMenuItem") performSelector:@selector(insertInMainMenu)];
    }
#endif
    
    self.window.backgroundColor = [NSColor whiteColor];
}

- (void)_configureWithCurrentEffectDefinition
{
    if (!self.effectDefinition) return;
    
    [self _createProductionForCurrentEffectDefinition];
    
    self.window.title = [NSString stringWithFormat:@"Effect Editor - %@", self.effectDefinition.displayName];
    
    [self _buildInspectorUI];
}

- (void)_createProductionForCurrentEffectDefinition
{
    [self.productions removeAllObjects];
    
    NSError *error;
    if (![self.document customizeSchemaEffectDefinition:self.effectDefinition shouldReplaceExisting:NO error:&error]) {
        [[NSAlert alertWithError:error] runModal];
        [self close];
    }
    
    id objs = [self.document allObjectsForEntity:@"EffectStyleProduction" withSortDescriptors:nil];
    
    [objs enumerateObjectsUsingBlock:^(TDEffectStyleProduction *production, NSUInteger idx, BOOL *stop) {
        if (production.partDefinition.element.name != self.effectDefinition.name) return;
        
        [self.productions addObject:production];
    }];
}

- (void)_createStackView
{
    self.scrollView = [[NSScrollView alloc] initWithFrame:self.window.contentView.bounds];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.scrollView.contentView = [[AMFlippedClipView alloc] initWithFrame:self.window.contentView.bounds];
    
    self.scrollView.borderType = NSNoBorder;
    self.scrollView.drawsBackground = NO;
    self.scrollView.hasVerticalScroller = YES;
    
    [self.window.contentView addSubview:self.scrollView];
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.window.contentView.topAnchor constant:kViewPadding].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.window.contentView.bottomAnchor constant:-kViewPadding].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.window.contentView.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.window.contentView.trailingAnchor].active = YES;
    
    self.stackView = [[NSStackView alloc] initWithFrame:self.window.contentView.bounds];
    self.stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.scrollView.documentView = self.stackView;
    
    [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
}

- (void)_buildInspectorUI
{
    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    TDEffectStyleProduction *production = self.productions.firstObject;
    
    for (TDEffectRenditionSpec *rendition in production.renditions) {
        for (TDEffectComponent *component in rendition.components) {
            [self _buildInspectorUIForComponent:component];
        }
    }
}

- (void)_buildInspectorUIForComponent:(TDEffectComponent *)component
{
    NSBox *box = [[NSBox alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(self.stackView.bounds), 100.0)];
    box.boxType = NSBoxPrimary;
    box.title = component.effectType.displayName;
    box.translatesAutoresizingMaskIntoConstraints = NO;
    [box addConstraint:[NSLayoutConstraint constraintWithItem:box attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:NSHeight(box.bounds)]];
    
    [self.stackView addArrangedSubview:box];
    
    [box.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:kViewPadding].active = YES;
    [box.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:-kViewPadding].active = YES;
    
    [self _buildParameterControlsInBox:box forComponent:component];
}

- (void)_buildParameterControlsInBox:(NSBox *)box forComponent:(TDEffectComponent *)component
{
    NSView *previousParameterView = nil;
    
    for (TDEffectParameterValue *parameter in component.parameters) {
        NSView *parameterControls = [self _controlsForParameter:parameter];
        [box.contentView addSubview:parameterControls];
        
        if (previousParameterView) {
            [parameterControls.topAnchor constraintEqualToAnchor:previousParameterView.bottomAnchor constant:kViewPadding].active = YES;
        } else {
            [parameterControls.topAnchor constraintEqualToAnchor:box.contentView.topAnchor constant:kViewPadding].active = YES;
        }
        
        [parameterControls.leadingAnchor constraintEqualToAnchor:box.contentView.leadingAnchor].active = YES;
        [parameterControls.trailingAnchor constraintEqualToAnchor:box.contentView.trailingAnchor].active = YES;
        
        previousParameterView = parameterControls;
    }
}

- (NSView *)_controlsForParameter:(TDEffectParameterValue *)parameter
{
    AMEffectParameterControlType controlType = _AMControlTypeForEffectParameter(parameter);
    
    switch (controlType) {
        case AMEffectParameterControlTypeColorWell:
            return [self _colorControlsForParameter:parameter];
            break;
            
        default:
            return nil;
    }
}

- (__kindof NSView *)_colorControlsForParameter:(TDEffectParameterValue *)parameter
{
    NSView *containerView = [[NSView alloc] initWithFrame:NSZeroRect];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSColor *color = [AMSystemThemeStore effectColorWithPhysicalColor:parameter.colorValue];
    
    NSColorWell *colorWell = [[NSColorWell alloc] initWithFrame:NSZeroRect];
    colorWell.translatesAutoresizingMaskIntoConstraints = NO;
    [colorWell sizeToFit];
    
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSZeroRect];
    label.bordered = NO;
    label.bezeled = NO;
    label.drawsBackground = NO;
    label.editable = NO;
    label.selectable = NO;
    label.font = [NSFont labelFontOfSize:12.0];
    label.textColor = [NSColor labelColor];
    label.stringValue = parameter.parameterType.displayName;
    [label sizeToFit];
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [containerView addSubview:label];
    [containerView addSubview:colorWell];
    
    [containerView setFrameSize:NSMakeSize(0, 22.0)];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:NSHeight(containerView.bounds)]];
    
    [colorWell addConstraint:[NSLayoutConstraint constraintWithItem:colorWell attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:22.0]];
    [colorWell addConstraint:[NSLayoutConstraint constraintWithItem:colorWell attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:22.0]];
    
    [label.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor].active = YES;
    [label.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:kViewPadding].active = YES;
    [label.topAnchor constraintEqualToAnchor:containerView.topAnchor].active = YES;
    [colorWell.leadingAnchor constraintEqualToAnchor:label.trailingAnchor constant:kViewPadding].active = YES;
    [colorWell.centerYAnchor constraintEqualToAnchor:label.centerYAnchor].active = YES;
    
    colorWell.color = color;
    
    return containerView;
}

- (void)_dumpProductions
{
#ifdef DEBUG
    for (TDEffectStyleProduction *production in self.productions) {
        NSLog(@"## PRODUCTION: %@", production.displayName);
        
        for (TDEffectRenditionSpec *rendition in production.renditions) {
            NSLog(@"#### RENDITION: %@", rendition.renditionType.displayName);
            
            for (TDEffectComponent *component in rendition.components) {
                NSLog(@"###### COMPONENT: %@", component.effectType.displayName);
                
                for (TDEffectParameterValue *parameter in component.parameters) {
                    NSLog(@"######## PARAMETER: %@", parameter.parameterType.displayName);
                }
            }
        }
    }
#endif
}


@end
