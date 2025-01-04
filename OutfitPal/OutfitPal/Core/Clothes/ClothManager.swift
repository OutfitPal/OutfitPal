//
//  ClothManager.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/4/25.
//

import Foundation
import Foundation
import FirebaseFirestore
import SwiftUICore



final class ClothManager: ObservableObject {
    
    @EnvironmentObject var authManager: AuthManager
    private let db = Firestore.firestore()
    



    static let shared = ClothManager()
    
    private init() {}


 
    func addOutfit(for date: Date, outfit: String) {

    }

    func getCloth(for date: Date, completion: @escaping (String?) -> Void) {

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
