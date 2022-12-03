//
//  MoviesDetailsViewController.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import UIKit

class MoviesDetailsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearValueLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var genresValueLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castValueLabel: UILabel!
    @IBOutlet weak var photosCollection: UICollectionView!
    
    
    // MARK: - Properties
    var viewModel: MoviesDetailsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title  = viewModel?.currentMovie?.title ?? ""
        setUI()
        viewModel?.getPhotos {
            DispatchQueue.main.async {
                self.photosCollection.reloadData()
            }
        }
    }
    convenience init(viewModel: MoviesDetailsViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }

    
    private func setUI() {
        setData()
        setCollectionVieW()
    }
    private func setCollectionVieW() {
        photosCollection.dataSource = self
        photosCollection.delegate = self
        photosCollection.register(UINib(nibName: "\(MoviesDetailsPhotoCollectionViewCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(MoviesDetailsPhotoCollectionViewCell.self)")
    }
    private func setData() {
        yearLabel.text = "Year"
        yearValueLabel.text = "\(viewModel?.currentMovie?.year ?? 0)"
        genresLabel.text = "Geners"
        genresValueLabel.text = viewModel?.setGeners()
        castLabel.text = "Cast"
        castValueLabel.text = viewModel?.setCast()
    }

}
extension MoviesDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollection.dequeueReusableCell(withReuseIdentifier: "\(MoviesDetailsPhotoCollectionViewCell.self)", for: indexPath) as? MoviesDetailsPhotoCollectionViewCell
        if let photo = viewModel?.flickrPhotos[indexPath.row] {
            cell?.set(photo: photo)
        }
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfPhotos() ?? 0
    }
}

extension MoviesDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photosCollection.frame.width / 2 - 16, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

