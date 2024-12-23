import Flutter
import UIKit
import FamilyControls
import SwiftUI

public class ScreenTimeApiIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        NSLog("SCREENTIME_DEBUG: Plugin is being registered")
        let channel = FlutterMethodChannel(name: "screen_time_api_ios", binaryMessenger: registrar.messenger())
        let instance = ScreenTimeApiIosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        NSLog("SCREENTIME_DEBUG: Received method: \(call.method)")
        
        switch call.method {
        case "requestPermission":
            requestScreenTimePermission(result: result)
            
        case "selectAppsToDiscourage":
            showController()
            result(nil)
            
        case "encourageAll":
            FamilyControlModel.shared.encourageAll()
            FamilyControlModel.shared.saveSelection(selection: FamilyActivitySelection())
            result(nil)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func requestScreenTimePermission(result: @escaping FlutterResult) {
        NSLog("SCREENTIME_DEBUG: Starting fresh permission request")
        
        Task {
            do {
                let center = AuthorizationCenter.shared
                let status = center.authorizationStatus
                
                NSLog("SCREENTIME_DEBUG: Initial status: \(status)")
                
                NSLog("SCREENTIME_DEBUG: Requesting authorization...")
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                
                let newStatus = center.authorizationStatus
                NSLog("SCREENTIME_DEBUG: New status after request: \(newStatus)")
                
                DispatchQueue.main.async {
                    let isApproved = (newStatus == .approved)
                    NSLog("SCREENTIME_DEBUG: Returning result: \(isApproved)")
                    result(isApproved)
                }
                
            } catch {
                NSLog("SCREENTIME_DEBUG: Error during authorization: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    result(FlutterError(code: "PERMISSION_ERROR",
                                      message: error.localizedDescription,
                                      details: nil))
                }
            }
        }
    }
    
    func showController() {
        DispatchQueue.main.async { [weak self] in
            guard let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let controller = scenes.windows.first?.rootViewController as? FlutterViewController else {
                debugPrint("Could not get Flutter view controller")
                return
            }
            
            let selectAppVC = UIHostingController(rootView: ContentView(completion: { successful in
                controller.dismiss(animated: true) {
                    debugPrint("View controller dismissed with success: \(successful)")
                }
            }))
            selectAppVC.modalPresentationStyle = .formSheet
            controller.present(selectAppVC, animated: true)
        }
    }
}