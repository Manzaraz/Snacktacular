//
//  SnacktacularApp.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 19/01/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SnacktacularApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var spotVM = SpotViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(spotVM)
        }
    }
}
