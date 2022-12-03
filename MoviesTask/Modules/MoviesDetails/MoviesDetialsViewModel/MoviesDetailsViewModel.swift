//
//  MoviesDetailsViewModel.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation

protocol MoviesDetailsViewModelProtocol: AnyObject {
    var currentMovie: Movie? { get set }
    var flickrPhotos: [FlickrPhoto] { get set }
    
    func setGeners() -> String
    func setCast() -> String
    func getPhotos(completion: @escaping () -> Void)
    func numberOfPhotos() -> Int
}

class MoviesDetailsViewModel: MoviesDetailsViewModelProtocol {
    var currentMovie: Movie?
    var flickrPhotos: [FlickrPhoto] = []
    private let service = FlickrPhotosService()
    
    init(currentMovie: Movie) {
        self.currentMovie = currentMovie
    }
    
    func getPhotos(completion: @escaping () -> Void) {
        service.getPhotosFrom(title: currentMovie?.title ?? "", completion: { [weak self] photos in
            guard let self = self else { return }
            self.flickrPhotos = photos
            completion()
        })
    }
    
     func setGeners() -> String {
        var text = ""
        guard let geners = currentMovie?.genres else { return text }
        for (index, gener) in geners.enumerated() {
            if index == geners.count - 1 {
                text += "\(gener)"
            } else {
                text += "\(gener),"
            }
        }
        return text
    }
    
     func setCast() -> String {
        var text = ""
        guard let casts = currentMovie?.cast else { return text }
        for (index, cast) in casts.enumerated() {
            if index == casts.count - 1 {
                text += "\(cast)"
            } else {
                text += "\(cast),"
            }
        }
        return text
    }
    func numberOfPhotos() -> Int {
        return flickrPhotos.count
    }
}
