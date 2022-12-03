//
//  Movies.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation

struct Movies: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    let title: String
    let year: Int
    let rating: Int
    let genres: [String]
    let cast: [String]
}
