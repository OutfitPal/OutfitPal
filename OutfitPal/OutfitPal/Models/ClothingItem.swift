//
//  ClothingItem.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import Foundation


struct ClothingItem: Identifiable, Codable {
    let id: String
    let category: String
    let color: String
    let seasons: [String]
    let occasion: String?
    let imageURL: String?
    let addedDate: Date
}
