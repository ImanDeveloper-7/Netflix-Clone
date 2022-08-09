//
//  Discover.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 08/08/2022.
//

import Foundation

// MARK: - DiscoverMovie
struct DiscoverMovie: Codable {
    let page: Int
    let results: [MovieRes]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
