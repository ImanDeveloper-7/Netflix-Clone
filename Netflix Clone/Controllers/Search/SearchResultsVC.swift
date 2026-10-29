//
//  SearchResultsVC.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 08/08/2022.
//

import UIKit
import SDWebImage

class SearchResultsVC: UIViewController {
    
    
    public let collection_search: UICollectionView = {

        let layout = UICollectionViewFlowLayout()

        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12

        layout.sectionInset = UIEdgeInsets(
            top: 12,
            left: 10,
            bottom: 12,
            right: 10
        )

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.register(
            MovieCollectionViewCell.nib(),
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )

        collectionView.backgroundColor = .systemBackground

        return collectionView
    }()
    
    public var movies: [MovieRes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.collection_search)
        self.collection_search.delegate = self
        self.collection_search.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collection_search.frame = self.view.bounds
    }
    
    
    public func updateMovies(_ newMovies: [MovieRes]) {
        if Thread.isMainThread {
            movies = newMovies
            loadViewIfNeeded()
            collection_search.reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.updateMovies(newMovies)
            }
        }
    }

}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { fatalError("MovieCollectionViewCell not found") }
        
        let movie = self.movies[indexPath.row]
        if let poster = movie.posterPath {
            cell.configureCell(with: poster)
        }
        
        return cell
    }

    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let spacing: CGFloat = 8
        let horizontalInset: CGFloat = 20

        let availableWidth = collectionView.bounds.width
            - horizontalInset
            - (spacing * 2)

        let width = floor(availableWidth / 3)

        return CGSize(width: width, height: width * 1.5)
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


