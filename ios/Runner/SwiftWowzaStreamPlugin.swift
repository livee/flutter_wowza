import Flutter
import UIKit
import AVFoundation

public class SwiftWowzaStreamPlugin: NSObject, FlutterPlugin, VideoViewControllerDelegate {
    
    public static var viewController = UIViewController()
    public static var lineColor:String=""
    public static var cancelButtonText:String=""
    public static var isShowFlashIcon:Bool=false
    var pendingResult:FlutterResult!
    public static var isContinuousScan:Bool=false
    static var barcodeStream:FlutterEventSink?=nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        viewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let channel = FlutterMethodChannel(name: "test_activity", binaryMessenger: registrar.messenger())
        let instance = SwiftWowzaStreamPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>;
        if let colorCode = args["lineColor"] as? String{
            SwiftWowzaStreamPlugin.lineColor = colorCode
        }else {
            SwiftWowzaStreamPlugin.lineColor = "#ff6666"
        }

        let controller = VideoViewController()
        controller.delegate = self

        SwiftWowzaStreamPlugin.viewController.present(controller, animated: true) {}
    }
}
