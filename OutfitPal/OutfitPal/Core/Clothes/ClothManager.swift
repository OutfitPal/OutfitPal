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



final class ClothManager: ObservableObject {
    
    @EnvironmentObject var authManager: AuthManager
    private let db = Firestore.firestore()
    private var userId: String?{ authManager.currentUser?.id}
    private let storage = Storage.storage()


    static let shared = ClothManager()
    
    private init() {}


 
    func addCloth(name: String, category: String, color: String, season: String, occasion: String?, selectedImage: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = userId else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        if let selectedImage = selectedImage {
            uploadImageToFirebase(image: selectedImage) { imageURL in
                let newClothingItem = ClothingItem(
                    id: UUID().uuidString,
                    name: name,
                    category: category,
                    color: color,
                    season: season,
                    occasion: occasion?.isEmpty == true ? nil : occasion,
                    imageURL: imageURL,
                    addedDate: Date()
                )

                self.saveClothingToFirestore(userId: userId, clothingItem: newClothingItem, completion: completion)
            }
        } else {
            let newClothingItem = ClothingItem(
                id: UUID().uuidString,
                name: name,
                category: category,
                color: color,
                season: season,
                occasion: occasion?.isEmpty == true ? nil : occasion,
                imageURL: nil,
                addedDate: Date()
            )

            saveClothingToFirestore(userId: userId, clothingItem: newClothingItem, completion: completion)
        }
    }


    private func uploadImageToFirebase(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let imageID = UUID().uuidString
        let storageRef = storage.reference().child("clothes/\(imageID).jpg")

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

    
    private func saveClothingToFirestore(userId: String, clothingItem: ClothingItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists, var user = try? document.data(as: User.self) else {
                completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }

            // Add new clothing item to user's wardrobe
            user.wardrobe.append(clothingItem)

            do {
                try userRef.setData(from: user, merge: true)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Retrieve All Clothing Items
    func getClothes(completion: @escaping (Result<[ClothingItem], Error>) -> Void) {
        guard let userId = userId else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        let userRef = db.collection("users").document(userId)

        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists, let user = try? document.data(as: User.self) else {
                completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }

            completion(.success(user.wardrobe))
        }
    }
//    /// Fetches all stored outfits from Firestore.
//    func getAllClothes() {
//        db.collection("outfits").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching outfits: \(error.localizedDescription)")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.outfits.removeAll()
//            }
//
//            snapshot?.documents.forEach { document in
//                if let data = document.data(),
//                   let dateString = data["date"] as? String,
//                   let outfit = data["outfit"] as? String,
//                   let date = self.dateFromFormattedString(dateString) {
//                    DispatchQueue.main.async {
//                        self.outfits[date] = outfit
//                    }
//                }
//            }
//        }
//    }


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
