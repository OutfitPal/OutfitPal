//
//  ClothManager.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/4/25.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUICore
import FirebaseAuth


@MainActor
final class ClothManager: ObservableObject {
    
    private var authManager: AuthManager!  // Force unwrapped because it will be set
    private let db = Firestore.firestore()
    private var userId: String? { authManager.currentUser?.id }
    private let storage = Storage.storage()
    
    static let shared = ClothManager()
    
    private init() {}
    
    // Method to set up the auth manager
    func configure(with authManager: AuthManager) {
        self.authManager = authManager
    }

 
    func addCloth(name: String, category: String, color: String, seasons: [String], occasion: String?, selectedImage: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {

        if let selectedImage = selectedImage {
            uploadImageToCloudinary(image: selectedImage) { imageURL in
                let newClothingItem = ClothingItem(
                    id: UUID().uuidString,
                    name: name,
                    category: category,
                    color: color,
                    seasons: seasons,
                    occasion: occasion?.isEmpty == true ? nil : occasion,
                    imageURL: imageURL,
                    addedDate: Date()
                )

                self.saveClothingToFirestore(clothingItem: newClothingItem, completion: completion)
            }
        } else {
            let newClothingItem = ClothingItem(
                id: UUID().uuidString,
                name: name,
                category: category,
                color: color,
                seasons: seasons,
                occasion: occasion?.isEmpty == true ? nil : occasion,
                imageURL: nil,
                addedDate: Date()
            )

            saveClothingToFirestore(clothingItem: newClothingItem, completion: completion)
        }
    }

    private func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?) -> Void) {
        let cloudName = "dtywy6khv"
        let uploadPreset = "outfit_pal"
        let folder = "OutfitPal/clothes"

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Debug: Failed to convert image to data")
            completion(nil)
            return
        }

        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        // File data
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // Upload preset
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)

        // Folder path
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"folder\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(folder)\r\n".data(using: .utf8)!)

        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Debug: Failed to upload image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Debug: No data received from Cloudinary")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let url = json["secure_url"] as? String {
                        print("Debug: Successfully uploaded image to: \(url)")
                        completion(url)
                    } else {
                        print("Debug: Cloudinary response did not include a URL")
                        completion(nil)
                    }
                }
            } catch {
                print("Debug: Failed to parse Cloudinary response: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }

    private func saveClothingToFirestore(clothingItem: ClothingItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = userId else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        let userRef = db.collection("users").document(userId)
        print("Debug: Fetching user document for userId: \(userId)")

        // Convert ClothingItem to a dictionary using JSONEncoder
        do {
            let jsonData = try JSONEncoder().encode(clothingItem)
            guard let clothingDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Debug: Failed to convert ClothingItem to dictionary")
                completion(.failure(NSError(domain: "EncodingError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to encode clothing item"])))
                return
            }

            // Append clothing item to Firestore wardrobe array
            userRef.updateData([
                "wardrobe": FieldValue.arrayUnion([clothingDict])
            ]) { error in
                if let error = error {
                    print("Debug: Failed to update wardrobe: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("✅ Debug: Successfully added new clothing item to wardrobe")
                    completion(.success(()))
                }
            }
        } catch {
            print("Debug: JSON encoding failed: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }


    func getClothes(completion: @escaping (Result<[ClothingItem], Error>) -> Void) {
        guard let userId = userId else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        let userRef = db.collection("users").document(userId)
        print("🔹 Fetching user document for ID: \(userId)")

        userRef.getDocument { document, error in
            if let error = error {
                print("❌ Firestore fetch error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists else {
                print("❌ Firestore: User document does not exist")
                completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }

            let documentData = document.data() ?? [:]
            print("✅ Firestore document data: \(documentData)")

            // Retrieve the wardrobe array
            if let wardrobeArray = documentData["wardrobe"] as? [[String: Any]] {
                do {
                    // Convert wardrobe dictionaries back into ClothingItem objects
                    let jsonData = try JSONSerialization.data(withJSONObject: wardrobeArray, options: [])
                    let decodedWardrobe = try JSONDecoder().decode([ClothingItem].self, from: jsonData)
                    
                    completion(.success(decodedWardrobe))
                } catch {
                    print("❌ Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                print("🔍 Wardrobe data is missing or empty")
                completion(.success([])) // Return empty array if wardrobe is missing
            }
        }
    }


    func removeCloth(for date: Date) {

    }

    // MARK: - Date Helpers

 
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

   
    private func dateFromFormattedString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}
