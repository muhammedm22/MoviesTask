//
//  MoviesDetailsPhotoCollectionViewCell.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import UIKit
import SDWebImage

class MoviesDetailsPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(photo: FlickrPhoto) {
        self.photo.sd_setImage(with: self.generateImage(farm: photo.farm, server: photo.server, id: photo.id, secret: photo.secret) )
    }
    
    private func generateImage(farm: Int, server: String, id: String, secret: String) -> URL? {
        let string = "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        return URL(string: string)
    }

}
