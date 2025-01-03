//
//  HomePageHeaderView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var authManager: AuthManager
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
            Button{
                ProfileView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    HeaderView()
}
