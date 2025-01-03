//
//  HorizontalMenuView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct HorizontalMenuView: View {
    @Binding var selectedSection: String

    struct MenuItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
    }

    let menuItems: [MenuItem] = [
        MenuItem(title: "Home", icon: "house.fill"),
        MenuItem(title: "Outfit Calendar", icon: "calendar"),
        MenuItem(title: "Digital Closet", icon: "folder.fill"),
        MenuItem(title: "Categories", icon: "list.bullet.rectangle"),
        MenuItem(title: "Wardrobe Insights", icon: "chart.bar.fill"),
        MenuItem(title: "Style Challenges", icon: "star.circle.fill"),
        MenuItem(title: "Fun Facts", icon: "info.circle.fill"),
        MenuItem(title: "Clothing Care", icon: "paintbrush")
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(menuItems) { item in
                    Button(action: {
                        selectedSection = item.title // Update the selected section
                    }) {
                        VStack {
                            Image(systemName: item.icon)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedSection == item.title ? .blue : .gray)

                            Text(item.title)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .foregroundColor(selectedSection == item.title ? .blue : .gray)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//    HorizontalMenuView(selectedSection: $selectedSection)
//}
