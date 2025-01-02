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
        Group{
            if authManager.userSession != nil{
                if !authManager.showAccountDeletedAlert{
                    BrowseTabView()}
                else{
                    
                }
                
            }
            else{
                SignInView()
            }
        }
        .alert("Account Deleted", isPresented: $authManager.showAccountDeletedAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Your account has been deleted. Please sign in again if you wish to continue using the app.")
                }
    }
}

#Preview {
    ContentView()
}
