//
//  OutfitOfTheDayView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct OutfitOfTheDayView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Outfit of the Day")
                .font(.headline)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Text("Casual: Red T-shirt and Black Jeans")
                            .font(.headline)
                        Text("Perfect for sunny weather!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                )
        }
        .padding(.horizontal)
    }
}

#Preview {
    OutfitOfTheDayView()
}
