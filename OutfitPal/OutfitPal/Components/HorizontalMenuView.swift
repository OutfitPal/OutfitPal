//
//  HorizontalMenuView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct HorizontalMenuView: View {
    @State private var selectedMenu: MenuItem? = nil

    struct MenuItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let view: AnyView
    }

    // Define menu items
    let menuItems: [MenuItem] = [
        MenuItem(title: "Outfit Calendar", icon: "calendar", view: AnyView(OutfitCalendarView())),
        MenuItem(title: "Digital Closet", icon: "folder.fill", view: AnyView(DigitalClosetView())),
        MenuItem(title: "Categories", icon: "list.bullet.rectangle", view: AnyView(CategoriesView())),
        MenuItem(title: "Wardrobe Insights", icon: "chart.bar.fill", view: AnyView(WardrobeInsightsView())),
        MenuItem(title: "Style Challenges", icon: "star.circle.fill", view: AnyView(StyleChallengesView())),
        MenuItem(title: "Fun Facts", icon: "info.circle.fill", view: AnyView(FunFactsAndStatsView())),
        MenuItem(title: "Clothing Care", icon: "paintbrush", view: AnyView(ClothingCareTipsView()))
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(menuItems) { item in
                    Button(action: {
                        selectedMenu = item // Assign the selected menu item
                    }) {
                        VStack {
                            Image(systemName: item.icon)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Text(item.title)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        // Display the sheet with the selected menu's view
        .sheet(item: $selectedMenu) { menu in
            menu.view
        }
    }
}

#Preview {
    HorizontalMenuView()
}
