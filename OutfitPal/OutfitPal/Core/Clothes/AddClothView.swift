//
//  AddClothingView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/3/25.
//
import SwiftUI
import PhotosUI


struct AddClothingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @State private var name = ""
    @State private var category = ""
    @State private var color = ""
    @State private var selectedSeasons: Set<String> = []  // Multi-selection
    @State private var occasion = ""
    @State private var showSeasonPicker = false  // Controls season picker visibility

    private let categories = [
        "Shirt", "T-shirt", "Sweater", "Hoodie", "Pants", "Jeans", "Shorts",
        "Jacket", "Coat", "Shoes", "Sneakers", "Boots", "Dress", "Suit", "Blazer",
        "Accessories", "Hat", "Scarf", "Gloves", "Skirt"
    ]

    private let seasons = ["Spring", "Summer", "Fall", "Winter"]

    var body: some View {
        NavigationStack {
            VStack {
                // Image Selection Section
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                } else {
                    Button(action: { showActionSheet = true }) {
                        Text("Choose or Take Photo")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(
                            title: Text("Select Image Source"),
                            buttons: [
                                .default(Text("Take a Photo")) {
                                    sourceType = .camera
                                    showImagePicker = true
                                },
                                .default(Text("Choose from Library")) {
                                    sourceType = .photoLibrary
                                    showImagePicker = true
                                },
                                .cancel()
                            ]
                        )
                    }
                }

                // Clothing Details Form
                Form {
                    Section(header: Text("Clothing Details")) {
                        TextField("Name", text: $name)

                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }

                        TextField("Color", text: $color)

                        // Multi-Selection Season Picker
                        Button(action: { showSeasonPicker.toggle() }) {
                            HStack {
                                Text("Season")
                                Spacer()
                                Text(selectedSeasons.isEmpty ? "Select Seasons" : selectedSeasons.joined(separator: ", "))
                                    .foregroundColor(selectedSeasons.isEmpty ? .gray : .primary)
                            }
                        }
                        .sheet(isPresented: $showSeasonPicker) {
                            MultiSeasonPicker(selectedSeasons: $selectedSeasons, seasons: seasons)
                        }

                        TextField("Occasion (Optional)", text: $occasion)
                    }

                    // Save Button
                    Button(action: addClothingItem) {
                        Text("Save Clothing Item")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("Add Clothing")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addClothingItem() {
        if name.isEmpty {
            showWarning(message: "Please enter a name for the clothing item.")
            return
        }
        if category.isEmpty {
            showWarning(message: "Please select a category.")
            return
        }
        if color.isEmpty {
            showWarning(message: "Please enter a color.")
            return
        }
        if selectedSeasons.isEmpty {
            showWarning(message: "Please select at least one season.")
            return
        }

        ClothManager.shared.addCloth(
            name: name,
            category: category,
            color: color,
            seasons: Array(selectedSeasons),  // Convert set to array
            occasion: occasion.isEmpty ? nil : occasion,
            selectedImage: selectedImage
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Clothing item added successfully!")
                    clearFields() // Clear input fields after success
                    
                case .failure(let error):
                    print("❌ Error adding clothing item: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showWarning(message: String) {
        alertMessage = message
        showAlert = true
    }

    // Function to reset input fields
    private func clearFields() {
        name = ""
        category = ""
        color = ""
        selectedSeasons.removeAll()
        occasion = ""
        selectedImage = nil
    }
}

// Custom Multi-Selection Sheet for Seasons
struct MultiSeasonPicker: View {
    @Binding var selectedSeasons: Set<String>
    let seasons: [String]

    var body: some View {
        NavigationStack {
            List {
                ForEach(seasons, id: \.self) { season in
                    MultipleSelectionRow(title: season, isSelected: selectedSeasons.contains(season)) {
                        if selectedSeasons.contains(season) {
                            selectedSeasons.remove(season)
                        } else {
                            selectedSeasons.insert(season)
                        }
                    }
                }
            }
            .navigationTitle("Select Seasons")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// Helper View for Multi-Selection
struct MultipleSelectionRow: View {
    let title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    AddClothingView()
}
