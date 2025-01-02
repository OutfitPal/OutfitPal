//
//  OutfitPalApp.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import SwiftUI
import Firebase

@main
struct OutfitPalApp: App {
    @StateObject var authManager = AuthManager()

    init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
