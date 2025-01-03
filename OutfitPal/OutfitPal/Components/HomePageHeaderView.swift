//
//  HomePageHeaderView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showProfileView = false // State to control the sheet

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Morning, \(authManager.currentUser?.fullName.components(separatedBy: " ").first ?? "User")")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Sunny, 25°C")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button {
                showProfileView = true // Show the settings view
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
            .sheet(isPresented: $showProfileView) {
                ProfileView() // Display ProfileView as a sheet
            }
        }
        .padding(.horizontal)
    }
}



#Preview {
    HeaderView()
}
