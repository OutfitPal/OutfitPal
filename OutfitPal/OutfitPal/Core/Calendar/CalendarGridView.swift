//
//  OutfitCalendarGridView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/3/25.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date?
    let currentMonth: Date
    private let calendar = Calendar.current

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
            // Days of the week header
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                Text(day)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }

            // Blank spaces for leading days
            ForEach(leadingDays(), id: \.self) { _ in
                Spacer()
                    .frame(width: 40, height: 40)
            }

            // Days in the current month
            ForEach(1...numberOfDaysInMonth(), id: \.self) { day in
                let date = createDate(for: day)
                Button(action: {
                    selectedDate = date
                }) {
                    Text("\(day)")
                        .font(.headline)
                        .frame(width: 40, height: 40)
                        .background(backgroundColor(for: date))
                        .foregroundColor(foregroundColor(for: date))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }

    private func leadingDays() -> [Int] {
        guard let firstDay = createDate(for: 1) else { return [] }
        let weekday = calendar.component(.weekday, from: firstDay)
        return Array(1..<weekday)
    }

    private func numberOfDaysInMonth() -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else { return 30 }
        return range.count
    }

    private func createDate(for day: Int) -> Date? {
        var components = calendar.dateComponents([.year, .month], from: currentMonth)
        components.day = day
        return calendar.date(from: components)
    }

    private func backgroundColor(for date: Date?) -> Color {
        guard let date = date else { return Color.clear }
        if calendar.isDateInToday(date) {
            return Color.blue // Highlight for today's date
        } else if selectedDate == date {
            return Color.red // Highlight for selected date
        } else {
            return Color.gray.opacity(0.2) // Default background
        }
    }

    private func foregroundColor(for date: Date?) -> Color {
        guard let date = date else { return Color.black }
        if calendar.isDateInToday(date) {
            return Color.white // White text for today's date
        } else if selectedDate == date {
            return Color.white // White text for selected date
        } else {
            return Color.black // Default text color
        }
    }
}
//#Preview {
//    CalendarGridView()
//}
