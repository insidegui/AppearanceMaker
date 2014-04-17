# Appearance Maker

Create custom appearances to customize your app's look with NSAppearance

## What's NSAppearance?

[Check the docs](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSAppearance_Class/Reference/Reference.html). Even though Apple states you can create a custom appearance using Xcode, this is not currently available, so I've created this simple app that lets you make custom appearances.

## Download binary

If you just want to use It, [download the latest binary](https://raw.github.com/insidegui/AppearanceMaker/master/Binary/AppearanceMaker_latest.zip).

## How to use

Download, build & run, follow the instructions.

First you create an uicatalog file, then you export a "skeleton" (a directory structure containing the original images for each control).

After this is done you can edit the PSDs, then you export the .car file, put It in your bundle and use It :)

	self.window.appearance = [[NSAppearance alloc] initWithAppearanceNamed:@"Your-appearance-name" bundle:nil];
	
Appearance Maker itself uses a custom appearance:

![screenshot](https://raw.github.com/insidegui/AppearanceMaker/master/screenshot_1.png)

## Can I use this and sell on the App Store?

Well, here's the thing: we are using private APIs to create the custom file, but NSAppearance itself is public, so the bottom line is yes, you can!

## Contributing

You can contribute with code, just send me a pull request, or open an issue for any bug/enhancement.

Disclaimer: sending a pull request does not mean I will accept It, if I don't accept your pull request It doesn't mean I don't love you ;)