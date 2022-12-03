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

    // MARK: - Properties
    private var viewModel: MoviesListViewModelProtocol?
    // custom Init
    convenience init(viewModel: MoviesListViewModel = MoviesListViewModel()) {
        self.init()
        self.viewModel = viewModel
    }
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    // MARK: - METHODS
    private func setUI() {
        setTableView()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section + 1)"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  "Movie \(indexPath.row)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
}