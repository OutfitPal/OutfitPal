//
//  OutfitOfTheDayView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct OutfitOfTheDayView: View {
    let date: Date?

    private var formattedDate: String {
            if let date = date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return "Outfit for \(formatter.string(from: date))"
            } else {
                return "Outfit of the Day"
            }
        }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Outfit for \(formattedDate)")
                .font(.headline)

            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 400)
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
    OutfitOfTheDayView(date: nil)
}
