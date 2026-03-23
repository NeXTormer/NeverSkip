import Foundation
import WatchConnectivity
import Flutter

class WatchConnector: NSObject, WCSessionDelegate {
    private let channel: FlutterMethodChannel
    
    init(messenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(name: "io.hawkford.frederic/watch", binaryMessenger: messenger)
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        setupMethodChannel()
    }
    
    private func setupMethodChannel() {
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "updateApplicationContext":
                if let args = call.arguments as? [String: Any] {
                    self.updateContext(data: args, result: result)
                }
            case "sendDataToWatch":
                if let args = call.arguments as? [String: Any] {
                    self.sendToWatch(data: args, result: result)
                }
            case "getPendingSets":
                self.flushPendingSets()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func updateContext(data: [String: Any], result: @escaping FlutterResult) {
        do {
            try WCSession.default.updateApplicationContext(data)
            result(nil)
        } catch {
            result(FlutterError(code: "WATCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func sendToWatch(data: [String: Any], result: @escaping FlutterResult) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(data, replyHandler: nil) { error in
                // It's okay if it fails
            }
            result(nil)
        } else {
            result(FlutterError(code: "WATCH_ERROR", message: "Watch not reachable", details: nil))
        }
    }
    
    private func flushPendingSets() {
        if let pendingSets = UserDefaults.standard.array(forKey: "pendingSets") as? [[String: Any]], !pendingSets.isEmpty {
            self.channel.invokeMethod("receivedSets", arguments: pendingSets)
            UserDefaults.standard.removeObject(forKey: "pendingSets")
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.channel.invokeMethod("receivedDataFromWatch", arguments: message)
        }
    }
    
    // Handles background transfers (e.g. offline sets)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let newSets = userInfo["pendingSets"] as? [[String: Any]] {
            var pendingSets = UserDefaults.standard.array(forKey: "pendingSets") as? [[String: Any]] ?? []
            pendingSets.append(contentsOf: newSets)
            UserDefaults.standard.set(pendingSets, forKey: "pendingSets")
            
            // Try pushing to Flutter immediately if active
            DispatchQueue.main.async {
                self.flushPendingSets()
            }
        }
    }
}

