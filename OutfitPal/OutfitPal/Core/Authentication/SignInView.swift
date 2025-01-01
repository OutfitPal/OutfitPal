//
//  SignInView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import SwiftUI

struct SignInView: View {

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

            // Button
            VStack {
                Spacer()

                Button {
                    // TODO: Add sign-in logic here
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
                .padding(.bottom, 50) // Adjust bottom padding as needed
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
