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
    private var searchWorkItem: DispatchWorkItem?
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search Movie..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .systemRed
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        tbl_search.register(
            MovieCell.nib(),
            forCellReuseIdentifier: MovieCell.identifier
        )

        tbl_search.delegate = self
        tbl_search.dataSource = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true

        doGetDiscoverMovies()
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

            let query = (searchController.searchBar.text ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard let resultController = searchController.searchResultsController
                    as? SearchResultsVC else {
                return
            }

            // Cancel previous pending search
            searchWorkItem?.cancel()

            // Clear results for short or empty queries
            guard query.count >= 3 else {
                resultController.updateMovies([])
                return
            }

            let workItem = DispatchWorkItem { [weak self, weak resultController] in

                guard let self = self else { return }

                APICaller.shared.search(query: query) { result in

                    DispatchQueue.main.async {

                        // Ignore outdated responses
                        let currentQuery = (self.searchController.searchBar.text ?? "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)

                        guard currentQuery == query,
                              let resultController = resultController else {
                            return
                        }

                        switch result {
                        case .success(let movies):
                            resultController.updateMovies(movies)

                        case .failure(let error):
                            print("Search error: \(error)")
                            resultController.updateMovies([])
                        }
                    }
                }
            }

            searchWorkItem = workItem

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.4,
                execute: workItem
            )
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
            cell.configureCell(with: poster)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = self.movies[indexPath.row]
        
        if let movieTitle = movie.originalTitle {
            APICaller.shared.getYoutubeVideo(with: movieTitle + "trailer") { res in
                switch res {
                case .success(let videoElement):
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
                        vc.modalPresentationStyle = .fullScreen
                        vc.movies = movie
                        vc.movieTitle = movieTitle
                        vc.movieOverView = movie.overview ?? ""
                        vc.movieId = videoElement.id.videoID
                        
                        self.present(vc, animated: true)
                        print(videoElement.id)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
