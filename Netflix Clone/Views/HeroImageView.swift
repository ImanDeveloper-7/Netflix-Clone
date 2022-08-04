//
//  HeroImageView.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 02/08/2022.
//

import UIKit

class HeroImageView: UIView {
    
    private let heroImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "lego")
        return imageView
    }()
    
    private let playButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let downloadButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private func addGradient() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.heroImageView.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.heroImageView)
        self.addGradient()
        addSubview(self.playButton)
        addSubview(self.downloadButton)
        applyConstraints()
    }
    
    private func applyConstraints() {
        
        let playButtonConstraints = [
        
            self.playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            self.playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            self.playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
        
            self.downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            self.downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            self.downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
