//
//  FlickrMoviesResponse.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation

struct FlickrMoviesResponse: Codable {
    let photos: FlickrPhotos
}
struct FlickrPhotos: Codable {
    let photo: [FlickrPhoto]
}
struct FlickrPhoto: Codable {
    let id: String
    let secret: String
    let farm:Int
    let server: String
}
