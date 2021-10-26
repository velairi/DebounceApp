//
//  SearchRequest.swift
//  DebounceApp
//
//  Created by Valerie Don on 10/26/21.
//

import Foundation

struct SearchRequest: Codable {
    let query: String
    let sort: Sort
}

struct Sort: Codable {
    enum Direction: String, Codable {
        case ascending
        case descending
    }

    let direction: Direction
    let timestamp: String
}

