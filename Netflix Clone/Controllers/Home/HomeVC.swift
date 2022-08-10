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
    private var randomTrendingMovie: MovieRes?
    private var headerView: HeroImageView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.confidureHeaderView()
    }
    
    private func setupUI() {
        self.tbl_home.register(HomeMovieCell.nib(), forCellReuseIdentifier: HomeMovieCell.identifier)
        self.tbl_home.separatorStyle = .none
        
        self.headerView = HeroImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        self.tbl_home.tableHeaderView = self.headerView
        self.view.backgroundColor = .systemBackground
    }
    
    private func confidureHeaderView() {
        APICaller.shared.getTrendingMovies { res in
            switch res {
            case .success(let movies):
                let selectedMovie = movies.randomElement()
                self.randomTrendingMovie = selectedMovie
                self.headerView?.configureHeaderView(with: selectedMovie?.posterPath ?? "")
            case .failure(let error):
                print(error)
            }
        }
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
        
        switch indexPath.section {
            
        case Sections.trendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { res in
                switch res {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.trendingTv.rawValue:
            APICaller.shared.getTrendingTVs { res in
                switch res {
                case .success(let tvs):
                    cell.configure(with: tvs)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.popular.rawValue:
            APICaller.shared.getPopular { res in
                switch res {
                case .success(let populars):
                    cell.configure(with: populars)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.upcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { res in
                switch res {
                case .success(let upcomingMovies):
                    cell.configure(with: upcomingMovies)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.topRated.rawValue:
            APICaller.shared.getTopRated { res in
                switch res {
                case .success(let topRateds):
                    cell.configure(with: topRateds)
                case .failure(let error):
                    print(error)
                }
            }
            
        default:
            break
        }
        
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
