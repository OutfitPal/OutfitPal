//
//  ClothingItemView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/5/25.
//

import SwiftUI

struct ClothingItemView: View {
    let item: ClothingItem

    var body: some View {
        VStack {
            if let imageURL = item.imageURL, let url = URL(string: imageURL), !imageURL.isEmpty {

                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 110, height: 110)
                .cornerRadius(10)
            } else {
 
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .overlay(
                        Text("No Image")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

//#Preview {
//    ClothingItemView()
//}
