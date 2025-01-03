import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showNoAccountAlert = false
    
    var body: some View {
        Group {
            if let userSession = authManager.userSession {
                if authManager.currentUser != nil {
                    BrowseTabView()
                        .onAppear {
                            print("Debug: Loaded BrowseTabView for \(userSession.uid)")
                        }
//                } else if authManager.userSession != nil {
// 
//                    SignInView()
//                        .alert("Account Not Found", isPresented: $showNoAccountAlert) {
//                            Button("OK") {
//                                authManager.signOut()
//                                showNoAccountAlert = false
//                            }
//                        } message: {
//                            Text("No account exists with the provided credentials. Please sign up.")
//                        }
//                        .onAppear {
//                            showNoAccountAlert = true
//                        }
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
