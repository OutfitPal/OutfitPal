//
//  ProfileView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showAlert = false

    var body: some View {
        if let user = authManager.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 6) {
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)

                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }

                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear", tintColor: Color(.systemGray), title: "Version")

                        Spacer()

                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Section("Account") {
                    VStack(alignment: .leading) {
                        Button {
                            authManager.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", tintColor: .red, title: "Sign Out")
                        }}.listRowSeparator(.hidden)
                    VStack(alignment: .leading){

                        Button {
                            showAlert = true
                        } label: {
                            HStack {
                                   SettingsRowView(
                                       imageName: "xmark.circle.fill",
                                       tintColor: .red,
                                       title: "Delete Account"
                                   )
                                   Spacer() // Ensures proper alignment
                               }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete your account?"),
                                message: Text("This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    authManager.deleteAccount()
         
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        authManager.signOut()
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
