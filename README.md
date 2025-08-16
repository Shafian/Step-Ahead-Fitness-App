# Step Ahead Fitness App

SwiftUI iOS app that tracks workouts and recommends new ones using a Core ML recommender.

## Features
- Log workouts, view history, earn XP & levels
- ML-powered **Recommended Workouts** (Create ML Item Similarity)
- Simple sign-in (demo), dashboard, calendar

## Requirements
- Xcode 15+
- iOS 16+ (simulator or device)

## Project Structure
- `App/` – Swift sources, Xcode project, assets, shipped `.mlmodel`
- `ML/` – Create ML project and training CSVs for retraining

## Build & Run
1. Open `App/Step Ahead Fitness App.xcodeproj` in Xcode.
2. Select an iPhone simulator.
3. Run (⌘R).

## Retrain the Recommender
1. Export interactions from the app (Profile → **Export Interactions.csv**), or edit `ML/Interactions.csv`.
2. Open **Create ML**, import the CSV (users: `userID`, items: `workoutID`, ratings: `rating`).
3. Train → Output → **Export Model**.
4. Replace `App/ML/WorkoutRecommender_1.mlmodel` (update the class name in `RecommenderService` if it changes).
5. Build & run.

## Notes
- Workout IDs in the CSV **must match** `WorkoutCatalog.swift`.
- New workouts require retraining to be ranked by ML.

## License
MIT (or your choice)
