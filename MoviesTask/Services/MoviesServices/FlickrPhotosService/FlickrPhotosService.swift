//
//  FlickrPhotosService.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import Foundation
protocol FlickrPhotosServiceProtocol: AnyObject {
    func getPhotosFrom(title: String, completion: @escaping (_ images: [FlickrPhoto]) -> Void)
}
class FlickrPhotosService: FlickrPhotosServiceProtocol {
    private let apiKey = "e63816ce791202f67e5ca7ee9227bf91"
    
    func getPhotosFrom(title: String, completion: @escaping (_ images: [FlickrPhoto]) -> Void) {
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(self.apiKey)&text=\(title.replacingOccurrences(of: " ", with: ""))&format=json&nojsoncallback=1&per_page=100")
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response , error in
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(FlickrMoviesResponse.self, from: data)
                completion(responseData.photos.photo)
            } catch {
                print("Decode error:", error)
                return
            }
        }).resume()
    }

}
