//
//  ClothingCareTipsView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct ClothingCareTipsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Clothing Care Tips")
                .font(.headline)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    VStack {
                        Text("Tip:")
                            .font(.headline)
                        Text("Always air-dry your sweaters to prevent shrinking!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                )
        }
        .padding(.horizontal)
    }
}

#Preview {
    ClothingCareTipsView()
}
