//
//  OutfitManager.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/3/25.
//

import Foundation
import FirebaseFirestore



final class OutfitManager: ObservableObject {
    

    private let db = Firestore.firestore()
    

    @Published var outfits: [Date: String] = [:]


    static let shared = OutfitManager()
    
    private init() {}


 
    func addOutfit(for date: Date, outfit: String) {
        let dateKey = formattedDate(date)
        
        db.collection("outfits").document(dateKey).setData([
            "date": dateKey,
            "outfit": outfit
        ]) { error in
            if let error = error {
                print("Error adding outfit: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.outfits[date] = outfit
                }
                print("Outfit successfully saved for \(dateKey)")
            }
        }
    }

    func getOutfit(for date: Date, completion: @escaping (String?) -> Void) {
        let dateKey = formattedDate(date)
        
        db.collection("outfits").document(dateKey).getDocument { document, error in
            if let document = document, document.exists, let data = document.data(), let outfit = data["outfit"] as? String {
                DispatchQueue.main.async {
                    self.outfits[date] = outfit
                }
                completion(outfit)
            } else {
                completion(nil)
            }
        }
    }

//    /// Fetches all stored outfits from Firestore.
//    func getAllOutfits() {
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


    func removeOutfit(for date: Date) {
        let dateKey = formattedDate(date)
        
        db.collection("outfits").document(dateKey).delete { error in
            if let error = error {
                print("Error deleting outfit: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.outfits.removeValue(forKey: date)
                }
                print("Outfit deleted for \(dateKey)")
            }
        }
    }


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
