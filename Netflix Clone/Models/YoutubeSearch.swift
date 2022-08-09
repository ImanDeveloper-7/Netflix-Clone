//
//  Youtube.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 09/08/2022.
//

import Foundation

// MARK: - YoutubeSearch
struct YoutubeSearch: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let kind, etag: String
    let id: ID
}

// MARK: - ID
struct ID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
