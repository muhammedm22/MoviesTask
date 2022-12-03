//
//  MoviesServiceProtocol.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation

protocol MoviesServiceProtocol: AnyObject {
    func getMovies(completion: @escaping (Result<Movies, Error>) -> Void)
}
