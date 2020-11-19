import Flutter
import UIKit

public class SwiftDocumentFileSavePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "document_file_save", binaryMessenger: registrar.messenger())
    let instance = SwiftDocumentFileSavePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  
    if (call.method == "getPlatformVersion") {
        result("iOS " + UIDevice.current.systemVersion)
    } else if (call.method == "getBatteryPercentage") {
        result(UIDevice.current.batteryLevel)
    } else if (call.method == "saveFile") {
        let args = call.arguments as! Dictionary<String, Any>
        let data = args["data"] as! FlutterStandardTypedData
        let fileName = args["fileName"] as! String
        let mimeType = args["mimeType"] as! String
        saveFile(data: data, fileName: fileName, mimeType: mimeType)
        result(nil)
    }
  }
  
  private func saveFile(data: FlutterStandardTypedData, fileName: String, mimeType: String) {
    if let vc = UIApplication.shared.keyWindow?.rootViewController {
        let temporaryFolder = URL(fileURLWithPath: NSTemporaryDirectory())
        let temporaryFileURL = temporaryFolder.appendingPathComponent(fileName)
        do {
            try data.data.write(to: temporaryFileURL)
        } catch {
           print(error)
        }
        
        let activityController = UIActivityViewController(activityItems: [temporaryFileURL], applicationActivities: nil)
        activityController.excludedActivityTypes = [.airDrop, .postToTwitter, .assignToContact, .postToFlickr, .postToWeibo, .postToTwitter]
        if let popOver = activityController.popoverPresentationController {
          popOver.sourceView = vc.view
          popOver.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
          popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        vc.present(activityController, animated: true, completion: nil)
    }
  }
}
