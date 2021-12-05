//
//  RunnerApp.swift
//  applewatch WatchKit Extension
//
//  Created by Felix Holz on 04.12.21.
//

import SwiftUI

@main
struct RunnerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
