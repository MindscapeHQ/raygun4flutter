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
        let flutterArguments = call.arguments
        
        switch call.method {
        case "init":
            initRaygun(data: flutterArguments as? NSDictionary)
        case "setVersion":
            setVersion(data: flutterArguments as? NSDictionary)
        case "send":
            send(data: flutterArguments as? NSDictionary)
        case "setTags":
            setTags(tags: flutterArguments as? [String])
        case "setCustomData":
            setCustomData(customData: flutterArguments as? [String:Any])
        case "recordBreadcrumb":
            breadcrumb(data: flutterArguments as? NSDictionary)
        case "recordBreadcrumbObject":
            breadcrumbObject(data: flutterArguments as? NSDictionary)
        case "setUserId":
            setUserId(data: flutterArguments as? NSDictionary)
        case "setUser":
            setUser(data: flutterArguments as? NSDictionary)
        default:
            result(FlutterMethodNotImplemented)
            return
        }
        result(nil)
    }
    
    func initRaygun(data: NSDictionary?) {
        let apiKey = data?.value(forKey: "apiKey") as! String
        let version = data?.value(forKey: "version") as? String
        let raygunClient = RaygunClient.sharedInstance(apiKey: apiKey)
        raygunClient.applicationVersion = version
        raygunClient.enableCrashReporting()
    }
    
    func setVersion(data: NSDictionary?) {
        let version = data?.value(forKey: "version") as? String
        RaygunClient.sharedInstance().applicationVersion = version
    }
    
    func send(data: NSDictionary?) {
        let name = data?.value(forKey: "className") as! String
        let reason = data?.value(forKey: "reason") as! String
        let tags = data?.value(forKey: "tags") as? [String]
        var customData = data?.value(forKey: "customData") as? [String:Any] ?? [:]
        
        // Stacktrace is passed in the customData,
        // hacky solution for having stacktraces in iOS
        let stackRaw = data?.value(forKey: "stackTrace") as? String
        let stackSplit = stackRaw?.split(separator: ";").map { (s: Substring) -> String in
            String(s)
        }
        customData["stackTrace"] = stackSplit
        
        RaygunClient.sharedInstance().send(
            exceptionName: name,
            reason: reason,
            tags: tags,
            customData:customData
        )
    }
    
    func setTags(tags: [String]?) {
        RaygunClient.sharedInstance().tags = tags
    }
    
    func setCustomData(customData: [String:Any]?) {
        RaygunClient.sharedInstance().customData = customData
    }
    
    func breadcrumb(data: NSDictionary?) {
        let message = data?.value(forKey: "message") as! String
        RaygunClient.sharedInstance().recordBreadcrumb(message: message, category: nil, level: RaygunBreadcrumbLevel.info, customData: nil)
    }
    
    func breadcrumbObject(data: NSDictionary?) {
        let message = data?.value(forKey: "message") as! String
        let category = data?.value(forKey: "category") as? String
        let levelIndex = data?.value(forKey: "level") as? Int
        let level = {
            switch levelIndex {
            case 0:
                return RaygunBreadcrumbLevel.debug
            case 1:
                return RaygunBreadcrumbLevel.info
            case 2:
                return RaygunBreadcrumbLevel.warning
            case 3:
                return RaygunBreadcrumbLevel.error
            default:
                return RaygunBreadcrumbLevel.info
            }
        }() as RaygunBreadcrumbLevel
        let customData = data?.value(forKey: "customData") as? [String:Any]
        
        RaygunClient.sharedInstance().recordBreadcrumb(
            message: message,
            category: category,
            level: level,
            customData: customData
        )
    }
    
    func setUserId(data: NSDictionary?) {
        if let userId = data?.value(forKey: "userId") as? String {
            RaygunClient.sharedInstance().userInformation = RaygunUserInformation.init(identifier: userId)
        } else {
            RaygunClient.sharedInstance().userInformation = RaygunUserInformation.anonymousUser
        }
    }
    
    func setUser(data: NSDictionary?) {
        if let data = data {
            let identifier = data.value(forKey: "identifier") as! String
            let email = data.value(forKey: "email") as? String
            let fullName = data.value(forKey: "fullName") as? String
            let firstName = data.value(forKey: "firstName") as? String
            RaygunClient.sharedInstance().userInformation = RaygunUserInformation.init(
                identifier: identifier,
                email: email,
                fullName: fullName,
                firstName: firstName)
        } else {
            RaygunClient.sharedInstance().userInformation = RaygunUserInformation.anonymousUser
        }
    }
}
