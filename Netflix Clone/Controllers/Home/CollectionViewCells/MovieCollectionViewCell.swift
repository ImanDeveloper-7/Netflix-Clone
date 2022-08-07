//
//  MovieCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 02/08/2022.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img_movie: UIImageView!
    
    weak var parent: UIViewController?
    
    static let identifier = "MovieCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }
    
    public func configureCell(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        self.img_movie.sd_setImage(with: url)
    }
}
