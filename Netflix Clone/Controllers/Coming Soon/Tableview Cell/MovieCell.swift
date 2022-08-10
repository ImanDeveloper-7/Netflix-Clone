//
//  UpcomingMovieCell.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 08/08/2022.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var img_upcomingMovie: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_play: UIButton!
    
    static let identifier = "MovieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_play.layer.cornerRadius = 14
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieCell", bundle: nil)
    }
    
    public func configureCell(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        self.img_upcomingMovie.sd_setImage(with: url)
    }
}
