//
//  OutfitCalendarView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//


import SwiftUI

struct OutfitCalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date? = nil

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {  // Ensure NavigationStack is present
            VStack(spacing: 20) {
                // Month Navigation
                HStack {
                    Button(action: {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Text(monthYearString(for: currentMonth))
                        .font(.headline)

                    Spacer()

                    Button(action: {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)

                // Calendar Grid
                CalendarGridView(selectedDate: $selectedDate, currentMonth: currentMonth)

                if let selectedDate = selectedDate {
                    NavigationLink(destination: OutfitOfTheDayView(date: selectedDate)) {
                        Text("View Outfit for \(formattedDate(selectedDate))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                } else {
                    Text("Select a day to view the outfit.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
    }

    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    OutfitCalendarView()
}




// Addition: If user clicks on future date, ask them to plan outift for that day
