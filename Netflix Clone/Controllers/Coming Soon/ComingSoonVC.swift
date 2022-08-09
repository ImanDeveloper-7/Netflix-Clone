//
//  ComingSoonVC.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 01/08/2022.
//

import UIKit
import SDWebImage

class ComingSoonVC: UIViewController {

    @IBOutlet weak var tbl_upcomingMovies: UITableView!
    
    var movies: [MovieRes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tbl_upcomingMovies.register(MovieCell.nib(), forCellReuseIdentifier: MovieCell.identifier)
        self.tbl_upcomingMovies.separatorStyle = .none
        self.doGetUpcomingMovies()
    }
    
    private func doGetUpcomingMovies() {
        APICaller.shared.getUpcomingMovies { res in
            switch res {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.tbl_upcomingMovies.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ComingSoonVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError("HomeMovieCell not found") }
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
