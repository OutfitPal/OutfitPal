//
//  BrowseTabView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import SwiftUI

struct BrowseTabView: View {
    @State private var showAddClothingView = false

    var body: some View {
        TabView {
 
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .badge(2)
            
            
            Text("3D Model View Coming Soon")
                .tabItem {
                    Label("3D Model", systemImage: "figure.stand.dress.line.vertical.figure")
                }


           
            AddClothingView()
            .tabItem {
                Label("Add", systemImage: "plus.rectangle.fill")
            }


            // Shop Tab
            Text("Shop Coming Soon") // Placeholder
                .tabItem {
                    Label("Shop", systemImage: "bag.circle.fill")
                }

            // Community Tab
            Text("Community Coming Soon") // Placeholder
                .tabItem {
                    Label("Community", systemImage: "globe")
                }
        }
    }
}

#Preview {
    BrowseTabView()
}
