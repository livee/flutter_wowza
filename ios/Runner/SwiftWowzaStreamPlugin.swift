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

        let storyboard = UIStoryboard(name: "VideoView", bundle: nil)
        let videoViewController:VideoViewController = storyboard.instantiateViewController(withIdentifier: "VideoViewControllerID") as! VideoViewController;
        videoViewController.delegate = self
        
        var goCoderConfig = WowzaConfig()
        let SDKSampleSavedConfigKey = videoViewController.SDKSampleSavedConfigKey

        if let savedConfig:Data = UserDefaults.standard.object(forKey: SDKSampleSavedConfigKey) as? Data {
            if let wowzaConfig = NSKeyedUnarchiver.unarchiveObject(with: savedConfig) as? WowzaConfig {
                goCoderConfig = wowzaConfig
            }
        }

        if let hostAddress = args["host_address"] as? String{
            goCoderConfig.hostAddress = hostAddress
        }

        if let portNumber = args["port_number"] as? UInt{
            goCoderConfig.portNumber = portNumber
        }
        
        if let appName = args["app_name"] as? String{
            goCoderConfig.applicationName = appName
        }
        
        if let streamName = args["stream_name"] as? String{
            goCoderConfig.streamName = streamName
        }

        let savedConfigData = NSKeyedArchiver.archivedData(withRootObject: goCoderConfig)
        UserDefaults.standard.set(savedConfigData, forKey: SDKSampleSavedConfigKey)
        UserDefaults.standard.synchronize()

        SwiftWowzaStreamPlugin.viewController.present(videoViewController, animated: true, completion: nil)
    }
}
