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
                    Button(action: saveClothingItem) {
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
        }
    }

    // MARK: - Save to Firebase
    private func saveClothingItem() {
        guard let selectedImage = selectedImage else { return }

        uploadImageToFirebase(image: selectedImage) { imageURL in
            let newClothing = ClothingItem(
                id: UUID().uuidString,
                name: name,
                category: category,
                color: color,
                season: season,
                occasion: occasion.isEmpty ? nil : occasion,
                imageURL: imageURL,
                addedDate: Date()
            )

            saveClothingToFirestore(clothingItem: newClothing)
        }
    }

    private func uploadImageToFirebase(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("clothes/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString)
                } else {
                    completion(nil)
                }
            }
        }
    }

    private func saveClothingToFirestore(clothingItem: ClothingItem) {
        let db = Firestore.firestore()

        do {
            try db.collection("wardrobe").document(clothingItem.id).setData(from: clothingItem)
            print("Clothing item saved successfully")
            dismiss() // Close the view after saving
        } catch {
            print("Error saving clothing item: \(error.localizedDescription)")
        }
    }
}


#Preview {
    AddClothingView()
}
