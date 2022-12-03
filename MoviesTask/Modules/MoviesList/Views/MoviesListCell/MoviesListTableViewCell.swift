//
//  MoviesListTableViewCell.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieYear: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(movie: Movie) {
        movieTitle.text = movie.title
        movieRating.text = "Rate: \(movie.rating)"
        movieYear.text = "Year: \(movie.year)"
    }
    
}
