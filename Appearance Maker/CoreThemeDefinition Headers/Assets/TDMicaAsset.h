//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Oct  7 2015 21:36:47).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

@import Cocoa;

#import "TDAsset.h"

@interface TDMicaAsset : TDAsset

- (void)setAttributesFromCopyData:(id)arg1;
- (id)copyDataFromAttributes;
- (BOOL)hasProduction;
- (id)production;
- (BOOL)hasCursorProduction;

@property(retain, nonatomic) NSSet *productions;

@end

