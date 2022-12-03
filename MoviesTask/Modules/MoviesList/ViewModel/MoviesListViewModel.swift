//
//  MoviesListViewModel.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation

protocol MoviesListViewModelProtocol: AnyObject {
    var moviesList: [Movie] { get set }
    func getMoviesList(completion: @escaping () -> Void)
}

class MoviesListViewModel: MoviesListViewModelProtocol {
    
    var moviesList: [Movie] = []
    private var localService: MoviesServiceProtocol?
    
    init(service: MoviesServiceProtocol = MoviesLocalService()) {
        self.localService = service
        
    }
    func getMoviesList(completion: @escaping () -> Void) {
        localService?.getMovies(completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let.success(movies):
                self.moviesList = movies.movies
                completion()
            case let .failure(error):
                debugPrint(error)
            }
        
        })
    }
    
}
