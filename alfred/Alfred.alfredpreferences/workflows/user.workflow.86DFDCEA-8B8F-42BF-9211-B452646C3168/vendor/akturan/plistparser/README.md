# PHP Plist Parser

A PHP Class for Reading and Parsing XML Plist files 

### Install
Install using Composer.
```
composer require akturan/plistparser
```
### Quick usage

```
require_once 'PlistParser.php';
```
#### Plist to Array
```
$result = $plistParser->plistToArray("Info.plist");
```
#### Result
```
Array
(
    [CFBundleAllowMixedLocalizations] => 1
    [CFBundleDevelopmentRegion] => de_DE
    [CFBundleDisplayName] => Test
    [CFBundleExecutable] => ${EXECUTABLE_NAME}
    [CFBundleIcons] => Array
        (
            [UINewsstandIcon] => Array
                (
                    [CFBundleIconFiles] => Array
                        (
                            [0] => 1.png
                            [1] => 1@2x.png
                        )

                    [UINewsstandBindingEdge] => UINewsstandBindingEdgeBottom
                    [UINewsstandBindingType] => UINewsstandBindingTypeNewspaper
                )

        )

    [UIPrerenderedIcon] => 1
    [UIRequiredDeviceCapabilities] => Array
        (
            [0] => armv7
        )

    [UIRequiresFullScreen] => 1
    [UISupportedInterfaceOrientations] => Array
        (
            [0] => UIInterfaceOrientationPortrait
            [1] => UIInterfaceOrientationLandscapeLeft
            [2] => UIInterfaceOrientationLandscapeRight
        )

    [UISupportedInterfaceOrientations~ipad] => Array
        (
            [0] => UIInterfaceOrientationPortrait
            [1] => UIInterfaceOrientationPortraitUpsideDown
            [2] => UIInterfaceOrientationLandscapeLeft
            [3] => UIInterfaceOrientationLandscapeRight
        )

    [UIViewControllerBasedStatusBarAppearance] => 
)
```
#### Search key in Plist file
```
$result = $plistParser->searchKeyInPlist("Info.plist", "CFBundleDisplayName");
// Test
```
