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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 160)
        layout.minimumInteritemSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionview
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
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
                        vc.movieId = videoElement.id.videoID
                        self.parent?.present(vc, animated: true)
                        print(videoElement.id)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


