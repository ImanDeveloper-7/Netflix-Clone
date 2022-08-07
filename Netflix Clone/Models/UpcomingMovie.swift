//
//  UpcimongMovie.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 06/08/2022.
//

import Foundation

// MARK: - UpcomingMovie
struct UpcomingMovie: Codable {
    let dates: Dates
    let page: Int
    let results: [MovieRes]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}
