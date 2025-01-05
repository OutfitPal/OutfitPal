//
//  DigitalClosetView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI
import FirebaseFirestore

struct DigitalClosetView: View {
    @State private var selectedCategory: String = "All"
    
    @State private var clothes: [ClothingItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

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
             
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
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
                } else if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)")
                        .foregroundColor(.red)
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
                fetchClothes() // Fetch clothes when the view appears
            }
        }
    }

    // Fetch clothing items from Firestore
    private func fetchClothes() {
        isLoading = true
        errorMessage = nil

        ClothManager.shared.getClothes { result in
            DispatchQueue.main.async {  
                self.isLoading = false
                switch result {
                case .success(let fetchedClothes):
                    self.clothes = fetchedClothes
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Error fetching clothes: \(error.localizedDescription)")
                }
            }
        }
    }
}


// Clothing Item View

#Preview {
    DigitalClosetView()
}
