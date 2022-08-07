//
//  TopRated.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 06/08/2022.
//

import Foundation

// MARK: - TopRated
struct TopRated: Codable {
    let page: Int
    let results: [MovieRes]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
