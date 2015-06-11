//
//  AMExportViewController.m
//  Appearance Maker
//
//  Created by Guilherme Rambo on 11/06/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "AMPreviewViewController.h"

#import "AMBackgroundView.h"
#import "AMThemeDocument.h"

@interface AMPreviewViewController ()

@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSProgressIndicator *indeterminateProgressPreview;
@property (weak) IBOutlet AMBackgroundView *backgroundView;

@end

#define kAppearanceBundleName @"AppearancePreview"
#define kAppearanceBundleExt @"bundle"
#define kPreviewAppearanceName @"Preview"

@implementation AMPreviewViewController
{
    NSURL *_previewBundleURL;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self.representedObject saveDocument:nil];
    
    [self.backgroundView becomeFirstResponder];
    [self.indeterminateProgressPreview startAnimation:nil];
    [self.containerView setHidden:YES];
    
    [self _doPreview];
}

- (void)_doPreview
{
    NSError *error;
    if (![[NSFileManager defaultManager] copyItemAtURL:[[NSBundle mainBundle] URLForResource:kAppearanceBundleName withExtension:kAppearanceBundleExt] toURL:[self previewBundleURL] error:&error]) {
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    if (![[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:[self previewResourcesPath]] withIntermediateDirectories:NO attributes:nil error:&error]) {
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    dispatch_queue_t distillerQueue = dispatch_queue_create("Distiller", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(distillerQueue, ^{
        TDDistillRunner *runner = [[TDDistillRunner alloc] init];
        AMThemeDocument *doc = (AMThemeDocument *)self.representedObject;
        
        BOOL result = [runner runDistillWithDocumentURL:doc.fileURL outputURL:[self previewCarURL] attemptIncremental:NO forceDistill:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                [self _loadAndApplyAppearance];
            } else {
                NSLog(@"Distill failed");
            }
        });
    });
}

- (void)_loadAndApplyAppearance
{
    [self.backgroundView setHidden:YES];
    [self.containerView setHidden:NO];
    
    self.containerView.appearance = [[NSAppearance alloc] initWithAppearanceNamed:kPreviewAppearanceName bundle:[NSBundle bundleWithURL:[self previewBundleURL]]];
}

- (NSURL *)previewBundleURL
{
    if (!_previewBundleURL) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *destBundleFilename = [NSString stringWithFormat:@"%@_%d_%.0f.preview", kAppearanceBundleName,
                                        [NSProcessInfo processInfo].processIdentifier,
                                        [NSDate date].timeIntervalSince1970];
        _previewBundleURL = [NSURL fileURLWithPath:[NSString pathWithComponents:@[path, destBundleFilename]]];
    }
    
    return _previewBundleURL;
}

- (NSString *)previewResourcesPath
{
    NSString *path = [self previewBundleURL].path;
    
    return [NSString pathWithComponents:@[path, @"Contents", @"Resources"]];
}

- (NSURL *)previewCarURL
{
    return [NSURL fileURLWithPath:[NSString pathWithComponents:@[[self previewResourcesPath], [NSString stringWithFormat:@"%@.car", kPreviewAppearanceName]]]];
}

- (void)viewDidDisappear
{
    [[NSFileManager defaultManager] removeItemAtURL:[self previewBundleURL] error:nil];
    
    [super viewDidDisappear];
}

@end
