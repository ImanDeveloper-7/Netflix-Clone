//
//  MovieCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 02/08/2022.
//

import UIKit

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
}
