import SwiftUI
import HealthKit
import WatchKit
import Combine

class WorkoutManager: NSObject, ObservableObject, HKWorkoutSessionDelegate {
    @Published var isRunning = false
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?

    func requestAuthorization() {
        let typesToShare: Set = [HKQuantityType.workoutType()]
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, _ in }
    }

    func toggleWorkout() {
        if isRunning {
            session?.end()
            isRunning = false
        } else {
            startWorkout()
        }
    }

    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            session?.delegate = self
            session?.startActivity(with: Date())
            DispatchQueue.main.async {
                self.isRunning = true
            }
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.isRunning = (toState == .running || toState == .paused)
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isRunning = false
        }
    }
}

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack {
                Button(action: {
                    workoutManager.toggleWorkout()
                }) {
                    Text(workoutManager.isRunning ? "Stop Session" : "Start Session")
                        .font(.headline)
                        .padding()
                }
                .tint(workoutManager.isRunning ? .red : .green)
            }
            .tag(0)
            
            WorkoutListView()
                .tag(1)
            
            NowPlayingView()
                .tag(2)
        }
        .tabViewStyle(.page)
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct WorkoutListView: View {
    @StateObject var viewModel = WatchViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.activities) { activity in
                NavigationLink(destination: ActivityDetailView(viewModel: viewModel, activityId: activity.id)) {
                    VStack(alignment: .leading) {
                        Text(activity.name)
                            .font(.headline)
                        Text("\(activity.completedSets)/\(activity.targetSets) Sets")
                            .font(.subheadline)
                            .foregroundColor(activity.completedSets >= activity.targetSets ? .green : .secondary)
                    }
                }
            }
            .navigationTitle("Today")
            .overlay {
                if viewModel.activities.isEmpty && false {
                    Text("Open iPhone app to sync today's workout.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}

struct ActivityDetailView: View {
    @ObservedObject var viewModel: WatchViewModel
    let activityId: String
    
    @State private var reps: Int = 0
    @State private var weight: Double = 0.0
    @State private var initialized = false
    
    @State private var buttonFeedbackToggle = false
    
    var activity: WatchActivity? {
        viewModel.activities.first(where: { $0.id == activityId })
    }
    
    var body: some View {
        ScrollView {
            if let act = activity {
                
                    VStack(spacing: 8) {
                        Text(act.name)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        if act.type == "Weighted" {
                            Text("Previous: \(act.previousReps) reps @ \(String(format: "%.0f", act.previousWeight))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Previous: \(act.previousReps) reps")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("Reps:")
                            Stepper("\(reps)", value: $reps, in: 1...100)
                        }
                        
                        if act.type == "Weighted" {
                            VStack {
                                Text("Weight:")
                                Stepper(String(format: "%.0f", weight), value: $weight, in: 0...500, step: 5.0)
                            }
                        }
                        
                        Button(action: {
                            viewModel.logSet(for: act.id, reps: reps, weight: weight)
                            buttonFeedbackToggle.toggle()
                        }) {
                            Text("Log Set (\(act.completedSets))")
                                .fontWeight(.bold)
                        }
                        .tint(.blue)
                        .sensoryFeedback(.success, trigger: buttonFeedbackToggle)
                    }
                
                .padding()
                .onAppear {
                    if !initialized {
                        reps = act.previousReps
                        weight = act.previousWeight
                        initialized = true
                    }
                }
            } else {
                Text("Activity not found")
            }
        }
    }
}

#Preview {
    ContentView()
}
