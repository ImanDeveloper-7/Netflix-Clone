//
//  Movie.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 05/08/2022.
//

import Foundation

// MARK: - Movie
struct TrendingMovie: Codable {
    let page: Int
    let results: [MovieRes]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
