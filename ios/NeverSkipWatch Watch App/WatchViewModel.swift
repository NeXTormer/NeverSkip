import SwiftUI
import WatchConnectivity
import Combine

class WatchViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var activities: [WatchActivity] = []
    
    override init() {
        super.init()
        loadActivities()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func loadActivities() {
        if let data = UserDefaults.standard.data(forKey: "calendarActivities"),
           let saved = try? JSONDecoder().decode([WatchActivity].self, from: data) {
            self.activities = saved
        }
    }
    
    func saveActivities() {
        if let data = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(data, forKey: "calendarActivities")
        }
    }
    
    func logSet(for activityId: String, reps: Int, weight: Double) {
        if let index = activities.firstIndex(where: { $0.id == activityId }) {
            DispatchQueue.main.async {
                self.activities[index].completedSets += 1
                self.saveActivities()
            }
            
            let newSetDict: [String: Any] = [
                "activityId": activityId,
                "reps": reps,
                "weight": weight,
                "timestamp": Int64(Date().timeIntervalSince1970 * 1000)
            ]
            
            // Send to phone via background queue
            WCSession.default.transferUserInfo(["pendingSets": [newSetDict]])
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let acts = applicationContext["activities"] as? [[String: Any]] {
            var newActivities: [WatchActivity] = []
            for act in acts {
                if let id = act["id"] as? String,
                   let name = act["name"] as? String,
                   let tSets = act["targetSets"] as? Int,
                   let tReps = act["targetReps"] as? Int,
                   let type = act["type"] as? String {
                    
                    let pWeight = act["previousWeight"] as? Double ?? 0.0
                    let pReps = act["previousReps"] as? Int ?? tReps
                    
                    newActivities.append(WatchActivity(id: id, name: name, targetSets: tSets, targetReps: tReps, previousWeight: pWeight, previousReps: pReps, type: type))
                }
            }
            
            DispatchQueue.main.async {
                self.activities = newActivities
                self.saveActivities()
            }
        }
    }
}
