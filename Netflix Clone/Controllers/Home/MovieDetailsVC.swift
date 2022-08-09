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
    
    var movieTitle: String?
    var movieOverView: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_title.text = self.movieTitle
        self.lbl_overView.text = self.movieOverView
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
