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
    
    func showController() {
    DispatchQueue.main.async {
        guard let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let controller = scenes.windows.first?.rootViewController as? FlutterViewController else {
            return
        }
        
        let selectAppVC = UIHostingController(rootView: ContentView())
        let naviVC = UINavigationController(rootViewController: selectAppVC)
        naviVC.modalPresentationStyle = .fullScreen // Changed to fullScreen
        naviVC.isNavigationBarHidden = false // Ensure nav bar is visible
        
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        naviVC.navigationBar.standardAppearance = appearance
        naviVC.navigationBar.scrollEdgeAppearance = appearance
        naviVC.navigationBar.compactAppearance = appearance
        
        controller.present(naviVC, animated: true, completion: nil)
    }
}
}