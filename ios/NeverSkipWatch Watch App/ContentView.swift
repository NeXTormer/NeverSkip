import SwiftUI

struct ContentView: View {
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
                if viewModel.activities.isEmpty {
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
    
    var activity: WatchActivity? {
        viewModel.activities.first(where: { $0.id == activityId })
    }
    
    var body: some View {
        ScrollView {
            if let act = activity {
                VStack(spacing: 16) {
                    Text(act.name)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Reps:")
                        Spacer()
                        Stepper("\(reps)", value: $reps, in: 1...100)
                    }
                    
                    if act.type == "Weighted" {
                        HStack {
                            Text("Weight:")
                            Spacer()
                            Stepper(String(format: "%.1f", weight), value: $weight, in: 0...500, step: 2.5)
                        }
                    }
                    
                    Button(action: {
                        viewModel.logSet(for: act.id, reps: reps, weight: weight)
                    }) {
                        Text("Log Set (\(act.completedSets))")
                            .fontWeight(.bold)
                    }
                    .tint(.blue)
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
