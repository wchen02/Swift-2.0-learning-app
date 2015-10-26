### Swift Tutorial Series ###
http://jamesonquave.com/blog/tutorials/

1. [Hello World](http://jamesonquave.com/blog/developing-ios-apps-using-swift-tutorial/)
2. [Making a web API request and parsing the JSON](http://jamesonquave.com/blog/developing-ios-apps-using-swift-tutorial-part-2/)
3. [Some best practices using Protocols and Delegates](http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-3-best-practices/)
4. [Adding an interactive Table View](http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-4-adding-interactions/)
5. [Async image loading and caching](http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-5-async-image-loading-and-caching/)
6. [Interaction with multiple views](http://jamesonquave.com/blog/developing-ios-8-apps-using-swift-interaction-with-multiple-views/)
7. [Animations, Audio, and Custom Table View Cells](http://jamesonquave.com/blog/developing-ios-8-apps-using-swift-animations-audio-and-custom-table-view-cells/)

### Core Data in Swift Tutorial ###
1. [Core Data in Swift Tutorial (Part 1)](http://jamesonquave.com/blog/core-data-in-swift-tutorial-part-1/)
2. [Core Data in Swift Tutorial (Part 2)](http://jamesonquave.com/blog/core-data-in-swift-tutorial-part-2/)
3. [Core Data in Swift Tutorial (Part 3)](http://jamesonquave.com/blog/core-data-in-swift-tutorial-part-3/)
4. [Core Data in Swift Tutorial (Part 4) – Migrations](http://jamesonquave.com/blog/core-data-migrations-swift-tutorial/)

### Best Practices ###
- https://github.com/futurice/ios-good-practices


### Swift Reference page ###
- https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309


### UIScrollView Tutorial: Getting Started ###
http://www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift

### iOS Login and Signup Screen tutorial : Swift + XCode 6 + iOS 8 + JSON ###
https://dipinkrishna.com/blog/2014/07/login-signup-screen-tutorial-xcode-6-swift-ios-8-json/

### UITableView Tutorial: Adding Search ###
http://www.raywenderlich.com/76519/add-table-view-search-swift

### Creating a Sidebar Menu Using SWRevealViewController in Swift ###
http://www.appcoda.com/sidebar-menu-swift/

### Collection View ###
http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1

### Constraint ###
https://youtu.be/IwSTXY0awng

### iAd ###
http://www.learnswiftonline.com/reference-guides/adding-iad-swift-app/
http://codewithchris.com/iad-tutorial/

### Google AdMob ###
https://developers.google.com/mobile-ads-sdk/docs/dfp/ios/quick-start

### Installing CocoaPods on Mac OS X El Capitan ###
```bash
sudo gem install -n /usr/local/bin cocoapods
```
https://github.com/CocoaPods/CocoaPods/issues/3736#issuecomment-145200290

### Configuring Workspace to use CocoaPods for test
Open Podfile and add the following line: (replace MainTarget and MainTargetTests with your targets)
```
link_with 'MainTarget', 'MainTargetTests'
```
Then run pod install.

### Networking ###
http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
https://github.com/Alamofire/Alamofire

### How to build workspace/project into .ipa from command line
```bash
cd ~/Desktop/MyiOSApp/
# list out information about the workspace
xcodebuild -list [-project name.xcodeproj | -workspace name.xcworkspace]
 
# this command will build a .app file
xcodebuild -workspace MyiOSApp.xcworkspace -scheme MyiOSApp -configuration Debug -sdk iphoneos
 
# package that .app file into a .ipa
/usr/bin/xcrun -sdk iphoneos PackageApplication -v"${RELEASE_BUILDDIR}/${APPLICATION_NAME}.app" -o"${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${CODE_SIGNING_IDENTITY}" --embed "${PROVISONING_PROFILE}”
 
# Example: code sign and provisioning profile is ommited below because xcode picks them up from the workspace
xcrun -sdk iphoneos PackageApplication -v "~/Library/Developer/Xcode/DerivedData/MyiOSApp-aybxjqitpyptdsgiapjtalbiajvd/Build/Products/Debug-iphoneos/MyiOSApp.app" -o ~/Desktop/MyiOSApp.ipa
```

### Notification
http://www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1

### App Configuration File

#### Create .plist configuration file
Create new file ->iOS Resource -> Property List

#### Read Config
```
var myDict: NSDictionary?
if let path = NSBundle.mainBundle().pathForResource("AppConfig", ofType: "plist") {
    myDict = NSDictionary(contentsOfFile: path)
}
 
if let dict = myDict {
    usernameTextField.placeholder = dict["Placeholder"] as? String
}
```

### Create multiple app with same source codebase
If you find yourself in the position where having multiple targets in your iOS project would be useful: for instance you wish to make a production, staging and demo target with separate endpoints, then this guide should prove useful.

1. Start by opening your project in xCode 6 and clicking on your project header to display the existing targets.
2. Duplicate an existing target (preferably the original) and rename it (e.g "app_name production")
3. Navigate to this target, then build settings > packaging> product name. You will see "app_name copy". Change this to
```
${TARGET_NAME}
```
4. Right click on any folder in your project and go to Finder. make a new folder inside the project structure with a similar name to your target (e.g production)
5. Copy the config file, info.plist file and any other files you wish to be unique to this target into the folder
6. Drag this folder into your project in xCode to add it to the project bundle.
7. Click on the new info.plist file and make sure that no target membership is ticked in the right sidebar.
8. Delete the generated info.plist file that appeared (usually the last file in your project navigator)
9. Go into your target > general and specify an info.plist. This should be the one in your new target folder.
10. Click on your target in the top bar and from the dropdown select "manage scheme".
11. Remove the copy scheme by highlighting and selecting "-" at the bottom of the panel
12. Click on the "autocreate scheme" button
You should now have a separate target with unique files that will be used when this target is selected. Feel free to modify things like endpoints, authentication details, etc...

Ref: https://pugpig.zendesk.com/hc/en-us/articles/204412465-Adding-new-targets-to-xCode-6-projects
