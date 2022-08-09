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
    
    static let identifier = "MovieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
