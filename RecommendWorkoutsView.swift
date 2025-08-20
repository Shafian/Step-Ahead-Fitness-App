//
//  RecommendWorkoutsView.swift
//  Step Ahead Fitness App
//
//  Created by Al Shafian Bari on 1/20/25.
//

import SwiftUI

struct RecommendWorkoutsView: View {
    @EnvironmentObject var workoutData: WorkoutData
    @AppStorage("userID") private var userID: String = "User1"

    @State private var items: [WorkoutItem] = []
    @State private var isLoading = true
    @State private var errorText: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Getting recommendations…")
            } else if let errorText {
                VStack(spacing: 12) {
                    Text("Couldn’t get recommendations").font(.headline)
                    Text(errorText).font(.subheadline).foregroundColor(.secondary)
                    Button("Try Again") { loadRecommendations() }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                }
                .padding()
            } else {
                List(items) { w in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(w.name).font(.headline)
                        Text(w.details).font(.subheadline).foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.insetGrouped)
                .refreshable { loadRecommendations() }
            }
        }
        .navigationTitle("Recommended Workouts")
        .onAppear { loadRecommendations() }
    }

    // MARK: - Logic

    private func loadRecommendations() {
        isLoading = true
        errorText = nil

        // Build seed list from user's history (names must match catalog/CSV IDs)
        let historyIDs = workoutData.savedWorkouts
            .map { $0.name }
            .filter { ALL_WORKOUT_IDS.contains($0) }

        let seeds = Array(NSOrderedSet(array: historyIDs)).compactMap { $0 as? String }

        // Ask model (tries user-based first, then item-similarity with seeds)
        let topIDs = RecommenderService.shared.recommend(
            userID: userID,
            candidates: ALL_WORKOUT_IDS,
            seeds: seeds,
            k: 5
        )

        // Debug (remove later)
        print("🔎 seeds:", seeds)
        print("🔎 model IDs for \(userID):", topIDs)

        // Map back to catalog, preserving order
        var mapped = topIDs.compactMap { id in WORKOUT_CATALOG.first { $0.id == id } }

        // Cold-start / empty result fallback
        if mapped.isEmpty {
            if !seeds.isEmpty {
                mapped = seeds.compactMap { id in WORKOUT_CATALOG.first { $0.id == id } }
            }
            if mapped.isEmpty {
                mapped = fallbackFromHistory(limit: 5)
            }
            if mapped.isEmpty {
                mapped = Array(WORKOUT_CATALOG.prefix(3))
                errorText = "Using default suggestions until the model sees more data."
            }
        }

        items = mapped
        isLoading = false
    }

    /// Rank by frequency in user's history.
    private func fallbackFromHistory(limit: Int) -> [WorkoutItem] {
        let counts = Dictionary(grouping: workoutData.savedWorkouts, by: { $0.name })
            .mapValues { $0.count }

        let ranked = WORKOUT_CATALOG.sorted {
            (counts[$0.id] ?? 0) > (counts[$1.id] ?? 0)
        }
        return Array(ranked.prefix(limit))
    }
}

// MARK: - Preview

#Preview {
    // Mock environment with some saved workouts to seed recommendations
    let mock = WorkoutData()
    mock.savedWorkouts = [
        WorkoutEntry(name: "Morning Run – 5km", sets: 1, reps: 1, date: Date()),
        WorkoutEntry(name: "Yoga – 30 min", sets: 1, reps: 1, date: Date().addingTimeInterval(-86400)),
        WorkoutEntry(name: "Strength Training – 45 min", sets: 3, reps: 8, date: Date().addingTimeInterval(-2*86400))
    ]

    return NavigationStack {
        RecommendWorkoutsView()
            .environmentObject(mock)
    }
}
