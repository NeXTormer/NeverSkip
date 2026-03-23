import Foundation

struct WatchActivity: Identifiable, Codable {
    let id: String
    let name: String
    let targetSets: Int
    let targetReps: Int
    let previousWeight: Double
    let previousReps: Int
    let type: String
    
    var completedSets: Int = 0
}

struct WatchSet: Codable {
    let activityId: String
    let reps: Int
    let weight: Double
    let timestamp: Int64
}
