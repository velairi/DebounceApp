//
//  Prediction.swift
//  DebounceApp
//
//  Created by Valerie Don on 10/19/21.
//

import Foundation

struct Prediction: Codable {
    let predictions: [PredictionElement]
    let status: String
}

struct PredictionElement: Codable {
    let structuredFormatting: StructuredFormatting

    enum CodingKeys: String, CodingKey {
        case structuredFormatting
    }
}

struct StructuredFormatting: Codable {
    let mainText: String
    let secondaryText: String

    enum CodingKeys: String, CodingKey {
        case mainText
        case secondaryText
    }
}
