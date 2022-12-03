//
//  MoviesListViewModel.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation

protocol MoviesListViewModelProtocol: AnyObject {
    var moviesList: [Movie] { get set }
    var moviesSearchGroups: [MovieSectionModel] { get set }
    
    func getMoviesList(completion: @escaping () -> Void)
    func didTapDoneSearch(with text: String, completion: @escaping () -> Void)
    func didTapCancelSearch(completion: @escaping () -> Void)
    func titleForSection(index: Int) -> String
    func getItem(at index: Int, section: Int) -> Movie
    func getNumberOfItems(at section: Int) -> Int
    func getNumberOfSections() -> Int
    func didSelectItem(index: Int, section: Int, completion: (_ movie: Movie) -> Void)
}

class MoviesListViewModel: MoviesListViewModelProtocol {

    var moviesList: [Movie] = []
    var moviesSearchGroups: [MovieSectionModel] = []
    var moviesSearchList: [Movie] = []
    private var tempMovies: [Movie] = []
    private var searchEnabled: Bool = false
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
                self.tempMovies = movies.movies
                self.moviesSearchGroups.append(MovieSectionModel(title: "All movies", movies: self.moviesList))
                completion()
            case let .failure(error):
                debugPrint(error)
            }
        
        })
    }
    func getItem(at index: Int, section: Int) -> Movie {
        if searchEnabled {
            return moviesSearchGroups[section].movies[index]
        } else {
            return moviesList[index]
        }
    }
    func getNumberOfItems(at section: Int) -> Int {
        return searchEnabled ? moviesSearchGroups[section].movies.count : moviesList.count
    }
    func didTapDoneSearch(with text: String, completion: @escaping () -> Void) {
        searchEnabled = true
        moviesSearchGroups.removeAll()
        moviesSearchList = moviesList.filter({ movie in
            movie.title.contains(text)
        })
        let years = Array(Set(moviesSearchList.map{ $0.year })).sorted()
        for year in years {
            let movies = moviesSearchList.filter({ $0.year == year })
            let topRatedInYear = tempMovies.sorted{ $0.rating > $1.rating }
            let getFirstFiveItems = Array(topRatedInYear.prefix(5))
            let groupMovies = movies + getFirstFiveItems
            let group = MovieSectionModel(title: "\(year)", movies: groupMovies)
            moviesSearchGroups.append(group)
        }
        completion()
    }
    func didTapCancelSearch(completion: @escaping () -> Void) {
        searchEnabled = false
        moviesSearchList = []
        moviesSearchGroups = []
        moviesList = tempMovies
        moviesSearchGroups.append(MovieSectionModel(title: "All movies", movies: self.moviesList))
        completion()
    }
    
    func getNumberOfSections() -> Int {
        searchEnabled ? self.getCountOfYears() : 1
    }
    func titleForSection(index: Int) -> String {
        if searchEnabled {
            return moviesSearchGroups[index].title
        } else {
            return "All Movies"
        }
    }
    
    func didSelectItem(index: Int, section: Int, completion: (_ movie: Movie) -> Void) {
        if searchEnabled {
            let movie = self.moviesSearchGroups[section].movies[index]
            completion(movie)
        } else {
            let movie = self.moviesList[index]
            completion(movie)
        }
    }
    
    private func getCountOfYears() -> Int {
        let years = moviesSearchList.map{ $0.year }
        let setOfYears: Set = Set(years)
        return setOfYears.count
    }
    
    
}
