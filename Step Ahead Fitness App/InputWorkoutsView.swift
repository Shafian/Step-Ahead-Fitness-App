import SwiftUI
import Foundation // To use WorkoutEntry and WorkoutData from their original definition

struct InputWorkoutsView: View {
    @EnvironmentObject var workoutData: WorkoutData
    @State private var workoutName: String = ""
    @State private var sets: String = ""
    @State private var reps: String = ""
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Navigation to Calendar Button
                    NavigationLink(destination: CalendarView()) {
                        Text("Go to Calendar")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    Text("Log Your Workout")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // Workout Name Input
                    TextField("Workout Name", text: $workoutName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    // Sets Input
                    TextField("Number of Sets", text: $sets)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)

                    // Reps Input
                    TextField("Number of Reps", text: $reps)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)

                    // Date Picker
                    DatePicker("Workout Date", selection: $date, displayedComponents: .date)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    // Save Button
                    Button(action: saveWorkout) {
                        Text("Save Workout")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(8)
                    }

                    // Saved Workouts List
                    if !workoutData.savedWorkouts.isEmpty {
                        Text("Saved Workouts")
                            .font(.headline)
                            .padding(.top, 20)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(workoutData.savedWorkouts) { workout in
                                WorkoutEntryView(workout: workout) {
                                    workoutName = workout.name
                                    sets = "\(workout.sets)"
                                    reps = "\(workout.reps)"
                                    date = workout.date

                                    if let index = workoutData.savedWorkouts.firstIndex(where: { $0.id == workout.id }) {
                                        workoutData.savedWorkouts.remove(at: index)
                                    }
                                    workoutData.saveWorkouts()
                                } onDelete: {
                                    if let index = workoutData.savedWorkouts.firstIndex(where: { $0.id == workout.id }) {
                                        workoutData.savedWorkouts.remove(at: index)
                                    }
                                    workoutData.saveWorkouts()
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Input Workouts")
        }
        .onAppear {
            workoutData.loadWorkouts()
        }
    }

    func saveWorkout() {
        if !workoutName.isEmpty && !sets.isEmpty && !reps.isEmpty {
            if let setsInt = Int(sets), let repsInt = Int(reps) {
                let workout = WorkoutEntry(name: workoutName, sets: setsInt, reps: repsInt, date: date)
                workoutData.savedWorkouts.append(workout)
                workoutData.saveWorkouts()
                workoutName = ""
                sets = ""
                reps = ""
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct WorkoutEntryView: View {
    let workout: WorkoutEntry
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.name)
                .font(.headline)

            Text("Sets: \(workout.sets), Reps: \(workout.reps)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Date: \(formatDate(workout.date))")
                .font(.footnote)
                .foregroundColor(.gray)

            HStack {
                Button(action: onEdit) {
                    Text("Edit")
                        .foregroundColor(.white)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                Button(action: onDelete) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    InputWorkoutsView()
        .environmentObject(WorkoutData())
}
