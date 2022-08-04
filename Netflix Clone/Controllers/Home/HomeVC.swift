//
//  HomeVC.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 01/08/2022.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tbl_home: UITableView!
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "UpComing Movies", "Top Rated"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.tbl_home.register(HomeMovieCell.nib(), forCellReuseIdentifier: HomeMovieCell.identifier)
        
        let headerView = HeroImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        self.tbl_home.tableHeaderView = headerView
        self.view.backgroundColor = .systemBackground
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieCell.identifier, for: indexPath) as? HomeMovieCell
        else { fatalError("HomeMovieCell Not Found") }
        cell.parent = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.label
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
    }
}
