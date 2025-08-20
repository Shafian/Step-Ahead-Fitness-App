//
//  RecommenderService.swift
//  Step Ahead Fitness App
//
//  Created by Al Shafian Bari on 8/15/25.
//

import Foundation
import CoreML

final class RecommenderService {
    static let shared = RecommenderService()

    // Use typed class to load the compiled model, but talk to its raw MLModel so we can pass flexible inputs.
    private let coreModel: MLModel = {
        let model = try! WorkoutRecommender_1(configuration: MLModelConfiguration())
        return model.model
    }()

    /// Try user-based recommendation (userID + candidate list). If empty, try item-similarity using seeds (liked items).
    func recommend(userID: String,
                   candidates: [String],
                   seeds: [String],
                   k: Int = 5) -> [String] {

        // 1) Try user-based predict (if the model supports it)
        if let top = predictUserBased(userID: userID, candidates: candidates, k: k), !top.isEmpty {
            return top
        }

        // 2) Try item-similarity using seed items (most common for Item Similarity Recommender)
        if let top = predictItemSimilarity(seeds: seeds, k: k), !top.isEmpty {
            return top
        }

        // Nothing from the model
        return []
    }

    // MARK: - User-based (best effort; some models ignore userID)
    private func predictUserBased(userID: String, candidates: [String], k: Int) -> [String]? {
        do {
            let input = try MLDictionaryFeatureProvider(dictionary: [
                "userID": userID,
                "items": candidates
            ])
            let out = try coreModel.prediction(from: input)

            if let scores = out.featureValue(for: "scores")?.dictionaryValue as? [String: Double] {
                let ranked = scores.sorted { $0.value > $1.value }.map { $0.key }
                return Array(ranked.prefix(k))
            }
            if let recs = out.featureValue(for: "recommendations")?.stringValue {
                return [recs]
            }
            return []
        } catch {
            // If the model doesn't accept userID, this may throw. Just treat as unsupported.
            return nil
        }
    }

    // MARK: - Item-similarity (seeds -> similar items)
    private func predictItemSimilarity(seeds: [String], k: Int) -> [String]? {
        guard !seeds.isEmpty else { return [] }
        do {
            // For Item Similarity, Create ML expects "items" input = seed IDs
            let input = try MLDictionaryFeatureProvider(dictionary: [
                "items": seeds
            ])
            let out = try coreModel.prediction(from: input)

            if let scores = out.featureValue(for: "scores")?.dictionaryValue as? [String: Double] {
                // The model may return scores for items including/excluding seeds; usually excludes seeds.
                let ranked = scores.sorted { $0.value > $1.value }.map { $0.key }
                return Array(ranked.prefix(k))
            }
            if let recs = out.featureValue(for: "recommendations")?.stringValue {
                return [recs]
            }
            return []
        } catch {
            return nil
        }
    }
}
