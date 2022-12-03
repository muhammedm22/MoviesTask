//
//  MoviesLocalService.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation
protocol MoviesServiceProtocol: AnyObject {
    func getMovies(completion: @escaping (Result<Movies, Error>) -> Void)
}

class MoviesLocalService: MoviesServiceProtocol {
    private let jsonFileName = "movies"
    
    func getMovies(completion: @escaping (Result<Movies, Error>) -> Void){
        do {
            if let bundlePath = Bundle.main.path(forResource: jsonFileName, ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                if let movies = self.decodeMoviesFrom(type: Movies.self, data: jsonData) {
                    print(movies)
                    completion(.success(movies))
                }
            }
        } catch {
            completion(.failure(error))
            fatalError("Coudn't handle data from \(jsonFileName) JSON file")
        }
    }
    
    private func decodeMoviesFrom(type: Movies.Type, data: Data) -> Movies? {
        do {
            let decodedData = try JSONDecoder().decode(type,
                                                       from: data)
            return decodedData
        } catch {
            print("decode error")
        }
        return nil
    }
}
