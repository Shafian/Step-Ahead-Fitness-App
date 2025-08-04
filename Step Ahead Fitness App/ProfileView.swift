//
//  ProfileView.swift
//  Step Ahead Fitness App
//
//  Created by Al Shafian Bari on 1/24/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ProfileView: View {
    @EnvironmentObject var workoutData: WorkoutData

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("1") // Replace "profile" with the exact name of your image asset
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 20) {
                    Spacer()

                    Text("User Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    Text("Level \(workoutData.level)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)

                    // XP Bar
                    VStack {
                        Text("XP: \(workoutData.xp) / \(workoutData.xpThreshold)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .shadow(radius: 5)

                        ProgressView(value: Double(workoutData.xp), total: Double(workoutData.xpThreshold))
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .frame(height: 20)
                            .padding(.horizontal)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.6)) // Increased opacity for better contrast
                            )
                            .cornerRadius(10)
                    }

                    // Export Workouts Button
                    Button(action: {
                        if let exportedFile = workoutData.exportWorkoutHistory() {
                            let activityViewController = UIActivityViewController(activityItems: [exportedFile], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootViewController = windowScene.windows.first?.rootViewController {
                                rootViewController.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }) {
                        Text("Export Workouts")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    Spacer()

                    // Bottom Navigation Bar
                    HStack {
                        NavigationLink(destination: DashboardView()) {
                            VStack {
                                Image(systemName: "house.fill") // Home icon
                                    .font(.title2)
                                Text("Dashboard")
                                    .font(.caption)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        NavigationLink(destination: InputWorkoutsView()) {
                            VStack {
                                Image(systemName: "plus.circle") // Add icon
                                    .font(.title2)
                                Text("Input Workout")
                                    .font(.caption)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        NavigationLink(destination: CalendarView()) {
                            VStack {
                                Image(systemName: "calendar") // Calendar icon
                                    .font(.title2)
                                Text("Calendar")
                                    .font(.caption)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                }
                .padding()
            }
            .onAppear {
                workoutData.updateLevelIfNeeded()
            }
            .navigationBarHidden(true) // Hides the default navigation bar
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(WorkoutData()) // Provide a mock instance of WorkoutData
    }
}
