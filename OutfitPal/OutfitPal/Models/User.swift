//
//  User.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//

import Foundation


struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    var profilePictureURL: String? // Optional profile picture URL
    var wardrobe: [ClothingItem] // Array of clothing items owned by the user
    var savedOutfits: [Outfit] // Array of saved outfits
    var shoppingPreferences: ShoppingPreferences // User preferences for shopping
    var weeklySchedule: [Date: Outfit] // A dictionary to map dates to outfits
    var location: String? // Optional location for weather-based suggestions
    var followers: [String] // List of user IDs who follow this user
    var following: [String] // List of user IDs this user is following
    var joinedDate: Date // Date when the user joined the app

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}


extension User {
    static var MOCK_USER = User(
        id: "123",
        fullName: "Jane Doe",
        email: "jane.doe@example.edu",
        profilePictureURL: "https://example.com/jane.jpg",
        wardrobe: [],
        savedOutfits: [],
        shoppingPreferences: ShoppingPreferences(
            preferredBrands: ["Zara", "H&M"],
            preferredColors: ["Red", "Blue"],
            budgetRange: "$50-$100",
            size: "M"
        ),
        weeklySchedule: [:],
        location: "New York, NY",
        followers: [],
        following: [],
        joinedDate: Date()
    )
}
