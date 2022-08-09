//
//  SearchVC.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 01/08/2022.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tbl_search: UITableView!
    
    var movies: [MovieRes] = []
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search Movie..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .systemRed
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tbl_search.register(MovieCell.nib(), forCellReuseIdentifier: MovieCell.identifier)
        self.doGetDiscoverMovies()
        self.navigationItem.searchController = self.searchController
        self.searchController.searchResultsUpdater = self
    }
    
    private func doGetDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { res in
            switch res {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.tbl_search.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsVC else { return }
        
        APICaller.shared.search(query: query) { res in
            switch res {
            case .success(let movies):
                resultController.movies = movies
                DispatchQueue.main.async {
                    resultController.collection_search.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError("UpcomingMovieCell not found") }
        let movie = self.movies[indexPath.row]
        
        cell.lbl_title.text = movie.originalTitle
        if let poster = movie.posterPath {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(poster)") {
                cell.img_upcomingMovie.sd_setImage(with: url)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
