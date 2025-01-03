//
//  StyleChallengesView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct StyleChallengesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Style Challenges")
                .font(.headline)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay(
                    VStack {
                        Text("Today's Challenge:")
                            .font(.headline)
                        Text("Create a monochrome outfit!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                )
        }
        .padding(.horizontal)
    }
}


#Preview {
    StyleChallengesView()
}
