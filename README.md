# MOONAssistiveTouch

* 

* CocoaPods:

  ```c
  source 'https://github.com/darkThanBlack/MOONAssistiveTouch.git'
  
  platform :ios, '9.0'
  
  pod 'MOONAssistiveTouch', :git => 'https://github.com/darkThanBlack/MOONAssistiveTouch.git'
  ```

* Carthage:

  ```c
  github "darkThanBlack/MOONAssistiveTouch"
  ```

* Sample Codes JUST SEE SEE:

  ```objective-c
  #import "MOONAssistiveTouch/MOONATCore.h"
  
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[MOONATCore core]configMenuItemActions:nil];
      [[MOONATCore core] start];
  }
  ```

* Sample Codes TO USE:

  ```
  
  ```

* Demo:[DEMO](./MOONAssistiveTouch.xcodeproj)

* Document:[doxygen](./Doc/html/index.html)