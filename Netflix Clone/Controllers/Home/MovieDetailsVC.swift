//
//  MovieDetailsVC.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 01/08/2022.
//

import UIKit
import WebKit

class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_overView: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btn_download: UIButton!
    
    var movies: MovieRes?
    var movieTitle: String?
    var movieOverView: String?
    var movieId: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_title.text = self.movieTitle
        self.lbl_overView.text = self.movieOverView
        self.playVideo()
    }
    
    @IBAction func download(_ sender: UIButton) {
        if let movies = self.movies {
            CoreDataManager.shared.downloadMovie(with: movies) { res in
                switch res {
                case .success(_):
                    let alert = UIAlertController(title: "Added to favourite!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func playVideo() {
        guard let url = URL(string: "https://www.youtube.com/embed/\(self.movieId ?? "")") else { return }
        self.webView.load(URLRequest(url: url))
    }
}
