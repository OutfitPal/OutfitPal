//
//  SignInView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: .infinity)
                    .ignoresSafeArea()
            }
            VStack{
                // Button
                VStack(spacing: 2) {
                    Spacer()
                    
                    Button {
                        Task {
                            do {
                                try await authManager.signInWithGoogle()
                            } catch {
                                if (error as NSError).code == 401{
                                    showAlert = true
                                    alertMessage = "No account exists with the provided credentials"
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN WITH EMAIL")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(red: 0.72, green: 0.43, blue: 0.47)) // Rose Gold
                    .cornerRadius(10)
                    .padding(.bottom, 10) // Adjust bottom padding as needed
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Authentication Error"),
                            message: Text(alertMessage),
                            primaryButton: .default(Text("Create Account")) {
                                Task {
                                    try? await authManager.signUpWithGoogle()
                                }
                            },
                            secondaryButton: .cancel(Text("Cancel")) {
                                showAlert = false
                                alertMessage = ""
                            }
                        )
                    }
                    
                    
                }
                Button {
                    Task {
                        do {
                            try await authManager.signUpWithGoogle()
                        } catch {
                            print("Unable to create account")
                        }
                    }
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
