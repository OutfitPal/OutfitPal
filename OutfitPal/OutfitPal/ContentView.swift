//
//  ContentView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {

        Group {
                if let userSession = authManager.userSession {
                    if authManager.currentUser != nil {
                        BrowseTabView()
                            .onAppear {
                                print("Debug: Loaded BrowseTabView for \(userSession.uid)")
                            }
                    } else {
                        // Handle case where Firestore document does not exist
                        SignInView()
                            .alert("Account Not Found", isPresented: .constant(true)) {
                                Button("OK") {
                                    authManager.signOut()
                                }
                            } message: {
                                Text("No account exists with the provided credentials. Please sign up.")
                            }
                    }
                } else {
                    SignInView()
                }
            }
       
    }
}

#Preview {
    ContentView()
}
