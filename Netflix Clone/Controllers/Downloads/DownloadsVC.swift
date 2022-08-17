//
//  DownloadsVC.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 01/08/2022.
//

import UIKit

class DownloadsVC: UIViewController {
    
    @IBOutlet weak var tbl_favourites: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tbl_favourites.register(MovieCell.nib(), forCellReuseIdentifier: MovieCell.identifier)
        self.doGetFavouriteMovies()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Download"), object: nil, queue: nil) { _ in
            self.doGetFavouriteMovies()
        }
    }
    
    private func doGetFavouriteMovies() {
        
        CoreDataManager.shared.fetchMovies { res in
            switch res {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.tbl_favourites.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError("MovieCell not found") }
        
        let movie = self.movies[indexPath.row]
        if let poster = movie.posterPath {
            cell.configureCell(with: poster)
            cell.lbl_title.text = movie.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = self.movies[indexPath.row]
        
        let movieTitle = movie.title
        APICaller.shared.getYoutubeVideo(with: movieTitle ?? movie.originalName ?? "" + "trailer") { res in
            switch res {
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.movieTitle = movieTitle ?? movie.originalName ?? movie.movieTitle ?? ""
                    vc.movieOverView = movie.overview ?? ""
                    vc.movieId = videoElement.id.videoID
                    vc.isHidden = true
                    self.parent?.present(vc, animated: true)
                    print(videoElement.id)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let movie = self.movies[indexPath.row]
            CoreDataManager.shared.deleteMovie(model: movie) { res in
                switch res {
                case .success( _):
                    print("Delete Successful!")
                case .failure(let error):
                    print(error)
                }
            }
            
            self.movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tbl_favourites.reloadData()
            
        default:
            break
        }
    }
}
