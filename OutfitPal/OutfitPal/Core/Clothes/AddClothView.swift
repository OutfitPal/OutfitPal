//
//  AddClothView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/3/25.
//
import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

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
    @State private var season = ""
    @State private var occasion = ""

    private let categories = ["Shirt", "Pants", "Jacket", "Shoes", "Dress", "Accessories", "Skirt"]
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

                        Picker("Season", selection: $season) {
                            ForEach(seasons, id: \.self) { season in
                                Text(season)
                            }
                        }

                        TextField("Occasion (Optional)", text: $occasion)
                    }

                    // Save Button
                    Button{
                        addClothingItem()
                    }
                    label:{
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
                if season.isEmpty {
                    showWarning(message: "Please select a season.")
                    return
                }
            ClothManager.shared.addCloth(
                name: name,
                category: category,
                color: color,
                season: season,
                occasion: occasion.isEmpty ? nil : occasion,
                selectedImage: selectedImage
            ) { result in
                DispatchQueue.main.async {
  
                    switch result {
                    case .success:
                        print("✅ Clothing item added successfully!")
                        
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
}


#Preview {
    AddClothingView()
}
