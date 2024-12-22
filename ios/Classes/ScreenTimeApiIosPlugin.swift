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
                
                // Always request authorization
                NSLog("SCREENTIME_DEBUG: Requesting authorization...")
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                
                // Check status again after request
                let newStatus = center.authorizationStatus
                NSLog("SCREENTIME_DEBUG: New status after request: \(newStatus)")
                
                DispatchQueue.main.async {
                    // Only return true if explicitly approved
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
    
    @objc func onPressClose(){
        dismiss()
    }
    
    func showController() {
    DispatchQueue.main.async {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let windows = windowScene?.windows
        let controller = windows?.filter({ (w) -> Bool in
            return w.isHidden == false
        }).first?.rootViewController as? FlutterViewController
        
        let selectAppVC: UIViewController = UIHostingController(rootView: ContentView())
        let naviVC = UINavigationController(rootViewController: selectAppVC)
        naviVC.modalPresentationStyle = .formSheet
        controller?.present(naviVC, animated: true, completion: nil)
    }
}
    
    func dismiss(){
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let windows = windowScene?.windows
            let controller = windows?.filter({ (w) -> Bool in
                return w.isHidden == false
            }).first?.rootViewController as? FlutterViewController
            controller?.dismiss(animated: true, completion: nil)
        }
    }
}