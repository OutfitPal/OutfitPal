//
//  HomeView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//


import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HeaderView()

                    // Horizontal Menu
                    HorizontalMenuView()

                    // Outfit of the Day
                    OutfitOfTheDayView()


                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}




#Preview {
    HomePageView()
}
