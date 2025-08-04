/*
//  DaysInMonthView.swift
//  Step Ahead Fitness App
//
//  Created by Al Shafian Bari on 1/21/25.
*/

import SwiftUI

struct DaysInMonthView: View {
    @EnvironmentObject var workoutData: WorkoutData
    let selectedMonth: Int
    @State private var selectedDay: Int? = nil
    @State private var daysInMonth: [Int] = []

    var body: some View {
        VStack {
            Text("Days in \(monthName(for: selectedMonth))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(daysInMonth, id: \ .self) { day in
                    NavigationLink(destination: WorkoutsForDayView(selectedDay: day, selectedMonth: selectedMonth)) {
                        Text("\(day)")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(hasWorkouts(for: day) ? Color.green : Color.gray)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            daysInMonth = calculateDaysInMonth(month: selectedMonth)
        }
    }

    func monthName(for month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.monthSymbols[month - 1]
    }

    func calculateDaysInMonth(month: Int) -> [Int] {
        let calendar = Calendar.current
        let year = Calendar.current.component(.year, from: Date())
        let dateComponents = DateComponents(year: year, month: month)
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        return Array(range)
    }

    func hasWorkouts(for day: Int) -> Bool {
        let workoutsForDay = workoutData.savedWorkouts.filter { workout in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: workout.date)
            return components.month == selectedMonth && components.day == day
        }
        return !workoutsForDay.isEmpty
    }
}

#Preview {
    DaysInMonthView(selectedMonth: 1)
        .environmentObject(WorkoutData())
}
