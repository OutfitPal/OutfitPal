//
//  DigitalClosetView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct DigitalClosetView: View {
    @State private var selectedCategory: String = "All" // Default to 'All'
    @State private var clothes: [ClothingItem] = [] // Stores clothing items
    @State private var isLoading = true // Loading state

    private let categories = [
        "All", "Shirt", "T-shirt", "Sweater", "Hoodie", "Pants", "Jeans", "Shorts",
        "Jacket", "Coat", "Shoes", "Sneakers", "Boots", "Dress", "Suit", "Blazer",
        "Accessories", "Hat", "Scarf", "Gloves", "Skirt"
    ]

    var filteredClothes: [ClothingItem] {
        selectedCategory == "All" ? clothes : clothes.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Horizontal Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                //fetchClothes() // Refresh items when category is selected
                            }) {
                                Text(category)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                // Clothing Grid
                if isLoading {
                    ProgressView("Loading clothes...")
                        .padding()
                } else if filteredClothes.isEmpty {
                    Text("No items found for \(selectedCategory)")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                            ForEach(filteredClothes) { clothingItem in
                                ClothingItemView(item: clothingItem)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Digital Closet")
            .onAppear {
              //  fetchClothes() // Load clothes when the view appears
            }
        }
    }

    
}

// Clothing Item View

#Preview {
    DigitalClosetView()
}
