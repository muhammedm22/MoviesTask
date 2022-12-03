//
//  MoviesListViewController.swift
//  MoviesTask
//
//  Created by Mohamed Mahmoud on 03/12/2022.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties
    private var viewModel: MoviesListViewModelProtocol?
    // custom Init
    convenience init(viewModel: MoviesListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        self.viewModel?.getMoviesList(completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    // MARK: - METHODS
    private func setUI() {
        setTableView()
        setSearchBar()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "\(MoviesListTableViewCell.self)", bundle: .main) , forCellReuseIdentifier: "MoviesListTableViewCell")
    }

    private func setSearchBar() {
        searchBar.delegate = self
    }
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.moviesSearchGroups[section].title
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell") as? MoviesListTableViewCell
        let item = viewModel?.getItem(at: indexPath.row, section: indexPath.section)
        if let movie = item {
            cell?.set(movie: movie)
        }
        return cell ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.getNumberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfItems(at: section) ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.didSelectItem(index: indexPath.row, section: indexPath.section, completion: { [weak self] movie in
            guard let self = self else { return }
            let viewModel = MoviesDetailsViewModel(currentMovie: movie)
            let vc = MoviesDetailsViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        })
     
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.didTapDoneSearch(with: searchBar.text ?? "", completion: {
            self.tableView.reloadData()
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.viewModel?.didTapCancelSearch(completion: {
            self.tableView.reloadData()
        })
    }
}
