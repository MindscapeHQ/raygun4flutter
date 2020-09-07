#import "Raygun4flutterPlugin.h"
#if __has_include(<raygun4flutter/raygun4flutter-Swift.h>)
#import <raygun4flutter/raygun4flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "raygun4flutter-Swift.h"
#endif

@implementation Raygun4flutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRaygun4flutterPlugin registerWithRegistrar:registrar];
}
@end
