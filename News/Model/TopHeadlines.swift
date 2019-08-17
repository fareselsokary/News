//
//  TopHeadlines.swift
//  News
//
//  Created by fareselsokary on 8/15/19.
//  Copyright © 2019 Fares. All rights reserved.
//

import Foundation

// MARK: - TopHeadlines

struct TopHeadlines: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article

struct Article: Codable {
    let source: Source?
    let author, title, articleDescription, urlToImage: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case urlToImage, content
    }
}

// MARK: - Source

struct Source: Codable {
    let id, name: String?
}
