//
//  RecommendWorkoutsView.swift
//  Step Ahead Fitness App
//
//  Created by Al Shafian Bari on 1/20/25.
//

import SwiftUI

struct RecommendWorkoutsView: View {
    @State private var recommendedWorkouts: [String] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Recommended Workouts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                if recommendedWorkouts.isEmpty {
                    Text("Fetching recommendations...")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(recommendedWorkouts, id: \..self) { workout in
                        Text(workout)
                            .font(.body)
                            .padding()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Workout Suggestions")
            .onAppear {
                fetchRecommendedWorkouts()
            }
        }
    }

    func fetchRecommendedWorkouts() {
        // Mock data for now
        // Replace this with a Create ML model or API call to generate recommendations
        recommendedWorkouts = [
            "Full Body HIIT - 30 min",
            "Yoga for Flexibility - 20 min",
            "Strength Training - Upper Body",
            "Cardio Blast - 25 min",
            "Core Workout - 15 min"
        ]
    }
}

#Preview {
    RecommendWorkoutsView()
}
