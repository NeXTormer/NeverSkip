import SwiftUI
import WatchConnectivity
import Combine

class WatchViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var activities: [WatchActivity] = []
    
    override init() {
        super.init()
        loadActivities()
        
//            activities = [WatchActivity(id: "darm", name: "Underhand Dumbbell Bench Press", targetSets: 3, targetReps: 10, previousWeight: 40, previousReps: 8, type: "Weighted", completedSets: 1),
//                          WatchActivity(id: "darm2", name: "Explosive Bulgarian Split Squat", targetSets: 3, targetReps: 10, previousWeight: 40, previousReps: 8, type: "Weighted", completedSets: 1)]
        
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
    
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
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
            
            Task { @MainActor [weak self] in
                self?.activities = newActivities
                self?.saveActivities()
            }
        }
    }
}
