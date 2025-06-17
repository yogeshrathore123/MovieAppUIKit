//
//  MovieModel.swift
//  MovieAppUIKit
//
//  Created by Yogesh Rathore on 17/06/25.
//

import Foundation

struct MovieResponse: Decodable {
    
    let Search: [Movie]
}

struct Movie: Decodable {
    
    let title: String
    let year: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
    }
}
