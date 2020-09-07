import Flutter
import UIKit
import raygun4apple

public class SwiftRaygun4flutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.raygun.raygun4flutter/raygun4flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftRaygun4flutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let flutterArguments = call.arguments as? NSDictionary

    switch call.method {
    case "init":
        initRaygun(data: flutterArguments)
    case "send":
        send(data: flutterArguments)
    case "breadcrumb":
        breadcrumb(data: flutterArguments)
    case "userId":
        setUserId(data: flutterArguments, result: result)
    default: result(FlutterMethodNotImplemented)
    }
  }
    
    func initRaygun(data: NSDictionary?) {
        let apiKey = data?.value(forKey: "apiKey") as! String
        let raygunClient = RaygunClient.sharedInstance(apiKey: apiKey)
        raygunClient.enableCrashReporting()
    }

    func send(data: NSDictionary?) {
        let name = data?.value(forKey: "className") as? String ?? "[missing]"
        let reason = data?.value(forKey: "reason") as? String ?? "[missing]"
        let stackRaw = data?.value(forKey: "stackTrace") as? String ?? "[missing]"
        let stackSplit = stackRaw.split(separator: ";").map { (s: Substring) -> String in
            String(s)
        }

        RaygunClient.sharedInstance().send(
                exceptionName: name,
                reason: reason,
                tags: ["iOS", "Flutter"],
                customData: ["stackTrace": stackSplit]
        )
    }

    func breadcrumb(data: NSDictionary?) {
        let message = data?.value(forKey: "message") as? String ?? "[missing]"
        RaygunClient.sharedInstance().recordBreadcrumb(message: message, category: "", level: RaygunBreadcrumbLevel.info, customData: nil)
    }

    func setUserId(data: NSDictionary?, result: FlutterResult) {
        if let userId = data?.value(forKey: "userId") as? Int {
            RaygunClient.sharedInstance().userInformation = RaygunUserInformation.init(identifier: String(userId))
        } else {
            RaygunClient.sharedInstance().userInformation = RaygunUserInformation.anonymousUser
        }
        result(nil)
    }
}
