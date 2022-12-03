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
    // Loading All movies from local Service
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
    // Getting item by Section and index
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
    // Will handle search in all movies when user tap in done button in Search
    func didTapDoneSearch(with text: String, completion: @escaping () -> Void) {
        searchEnabled = true
        moviesSearchGroups.removeAll()
        moviesSearchList = moviesList.filter({ movie in
            movie.title.contains(text)
        })
        // Get all years from search result and conver to set to remove any duplication
        let years = Array(Set(moviesSearchList.map{ $0.year })).sorted()
        for year in years {
            let movies = moviesSearchList.filter({ $0.year == year })
            let topRatedInYear = tempMovies.sorted{ $0.rating > $1.rating }
            // getting the top 5 Rating items form all list
            let getFirstFiveItems = Array(topRatedInYear.prefix(5))
            let groupMovies = movies + getFirstFiveItems
            // Creating group of movies to show as section by Year
            let group = MovieSectionModel(title: "\(year)", movies: groupMovies)
            moviesSearchGroups.append(group)
        }
        completion()
    }
    // Handle disable search mode when user tap cancel in SearchBar
    func didTapCancelSearch(completion: @escaping () -> Void) {
        searchEnabled = false
        moviesSearchList = []
        moviesSearchGroups = []
        moviesList = tempMovies
        moviesSearchGroups.append(MovieSectionModel(title: "All movies", movies: self.moviesList))
        completion()
    }
    // getting the number of sections
    func getNumberOfSections() -> Int {
        searchEnabled ? self.getCountOfYears() : 1
    }
    // getting title For every section by Index
    func titleForSection(index: Int) -> String {
        if searchEnabled {
            return moviesSearchGroups[index].title
        } else {
            return "All Movies"
        }
    }
    // Handle selecting item from list for every Section by Index
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
