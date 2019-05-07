# MOONAssistiveTouch

### WO ZI JI YE KAN BU DONG

[简体中文版介绍](./README_CN.md)

### WHO AM I

A bundle of debug UI that looks like iOS system AssistiveTouch.

### HOW TO SETUP

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

###HOW TO USE

* JUST SEE SEE:

  ```objective-c
  #import "MOONAssistiveTouch/MOONATCore.h"
  
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[MOONATCore core]configMenuItemActions:nil];
      [[MOONATCore core] start];
  }
  ```

* Sample codes:

  ```objective-c
  //adapt cocoapods and carthage
  #import "MOONAssistiveTouch/MOONATCore.h"
  
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[MOONATCore core]configMenuItemActions:[self demoActions]];
      [[MOONATCore core] start];
  }
  
  - (NSArray<MOONATMenuItemAction *> *)demoActions
  {
      MOONATMenuItemAction *action_skin = [MOONATMenuItemAction actionWithTitle:@"换肤" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
          [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeChangeSkin params:nil];
          //do what you want to do
      }];
  
      MOONATMenuItemAction *action_delay = [MOONATMenuItemAction actionWithTitle:@"延时变淡" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
          [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeChangeDelayFade params:nil];
      }];
      
      MOONATMenuItemAction *action_absorb = [MOONATMenuItemAction actionWithTitle:@"吸附模式" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
          [action triggerAssistiveTouchAction:MOONAssistiveTouchActionModeChangeAbsorb params:nil];
      }];
      
      MOONATMenuItemAction *action_appearaence = [MOONATMenuItemAction actionWithTitle:@"特效设置" itemBlock:^(MOONATMenuItemAction * _Nonnull action) {
          
      }];
      
      action_appearaence.subActions = @[action_delay, action_absorb];
  	
      return @[action_skin, action_appearaence, action_sub];
  }
  ```

###HELPER

* [DEMO](./MOONAssistiveTouch.xcodeproj)
* [Doxygen](./Doc/html/index.html) include **BUG LIST**

### WHAT IS THIS?

* [What is CocoaPods?](<https://github.com/CocoaPods/CocoaPods>)
* [What is Carthage?](<https://github.com/Carthage/Carthage>)
* [What is Doxygen?](<http://www.doxygen.nl/>)

### LICENSE

[WTFPL](<http://www.wtfpl.net/about/>) – JUST DO WHAT THE F*CK YOU WANT TO DO.