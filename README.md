# Appearance Maker

Create custom appearances to customize your app's look with NSAppearance

![screenshot](https://raw.github.com/insidegui/AppearanceMaker/master/screenshot_new.png)

## How to use

[🎥 Check out this short video to see It in action](https://youtu.be/DL1ZzSuU2cA).

The basic workflow is:

* Create an Appearance Maker document
* Select the UI elements you want to customize and click "Customize"
* Edit the PSDs in Photoshop or equivalent and save
* Change colors and fonts (font customization is not implemented yet)
* Preview and export the `.CAR` file
* Add the `.CAR` file to your app's resources
* Load the appearance using `NSAppearance` and apply It to your views

Please note that Appearance Maker only works on OS X 10.11 and later and is not finished yet, some features are not working (mainly the effects and fonts editor).

## What's NSAppearance?

[Check the docs](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSAppearance_Class/Reference/Reference.html). Even though Apple states you can create a custom appearance using Xcode, this is not currently available, so I've created this app that lets you make custom appearances.
