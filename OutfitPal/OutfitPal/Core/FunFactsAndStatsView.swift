//
//  FunFactsAndStatsView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct FunFactsAndStatsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Fun Facts & Stats")
                .font(.headline)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    VStack {
                        Text("Your favorite color is Blue!")
                            .font(.headline)
                        Text("30% of your wardrobe is blue items.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                )
        }
        .padding(.horizontal)
    }
}


#Preview {
    FunFactsAndStatsView()
}
