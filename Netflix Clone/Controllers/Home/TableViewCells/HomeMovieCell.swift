//
//  TrendingMoviesCell.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 01/08/2022.
//

import UIKit

class HomeMovieCell: UITableViewCell {
    
    @IBOutlet weak var collection_movie: UICollectionView!
    
    weak var parent: UIViewController?
    private var movies: [MovieRes] = []
    
    static let identifier = "HomeMovieCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        self.collection_movie.delegate = self
        self.collection_movie.dataSource = self
        self.collection_movie.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        self.collection_movie.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeMovieCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(with movies: [MovieRes]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collection_movie.reloadData()
        }
    }
}

extension HomeMovieCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { fatalError("MovieCollectionViewCell not found") }
        cell.parent = self.parent
        
        let movie = self.movies[indexPath.row]
        if let poster = movie.posterPath {
            cell.configureCell(with: poster)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = self.movies[indexPath.row]
        
        if let movieTitle = movie.originalTitle {
            APICaller.shared.getYoutubeVideo(with: movieTitle + "trailer") { res in
                switch res {
                case .success(let videoElement):
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
                        vc.modalPresentationStyle = .fullScreen
                        vc.movieTitle = movieTitle
                        vc.movieOverView = movie.overview ?? ""
                        self.parent?.present(vc, animated: true)
                        print(videoElement.id)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}
