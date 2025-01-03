//
//  BrowseTabView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import SwiftUI

struct BrowseTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomePageView()
            }
            .badge(2)

            
            Tab("3D Model", systemImage: "figure.stand.dress.line.vertical.figure"){
                
            }
            
            Tab("Add", systemImage: "plus.rectangle.fill"){
                
            }
            
            
            Tab("Shop", systemImage: "bag.circle.fill") {

                        }

        
            Tab("Comunity", systemImage: "globe") {

            }

        }
    }
}

#Preview {
    BrowseTabView()
}
