import SwiftUI

struct HomePageView: View {
    @State private var selectedSection: String = "Home"

    var body: some View {
        NavigationStack{
            
            VStack(spacing: 20) {
                // Header
                HeaderView()
                
                // Horizontal Menu
                HorizontalMenuView(selectedSection: $selectedSection)
                
                // Content Section
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedSection {
                        case "Home":
                            OutfitOfTheDayView(date: nil)
                            
                        case "Outfit Calendar":
                            OutfitCalendarView()
                            
                        case "Digital Closet":
                            DigitalClosetView()
                            
                        case "Categories":
                            CategoriesView()
                            
                        case "Wardrobe Insights":
                            WardrobeInsightsView()
                            
                        case "Style Challenges":
                            StyleChallengesView()
                            
                        case "Fun Facts":
                            FunFactsAndStatsView()
                            
                        case "Clothing Care":
                            ClothingCareTipsView()
                            
                        case "Profile":
                            ProfileView()
                            
                        default:
                            Text("Unknown Section")
                        }
                    }
                    .padding()
                }
                .ignoresSafeArea(edges: .horizontal)
            }
            .ignoresSafeArea(edges: .horizontal)
            .padding(.top, 10)
        }}
}

#Preview {
    HomePageView()
}
