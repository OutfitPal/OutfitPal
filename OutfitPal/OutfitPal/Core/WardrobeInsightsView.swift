//
//  WardrobeInsightsView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct WardrobeInsightsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Wardrobe Insights")
                .font(.headline)
            HStack {
                VStack {
                    Text("50")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Total Items")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("10")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Most Worn")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("5")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("For Winter")
                        .font(.caption)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.2)))
        }
        .padding(.horizontal)
    }
}



#Preview {
    WardrobeInsightsView()
}
