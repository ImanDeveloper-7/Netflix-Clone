//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 05/08/2022.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let url = URL(string: "\(K.baseUrl)/3/trending/movie/day?api_key=\(K.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let movie = try JSONDecoder().decode(TrendingMovie.self, from: data)
                completion(.success(movie.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let url = URL(string: "\(K.baseUrl)/3/trending/tv/day?api_key=\(K.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let tv = try JSONDecoder().decode(TrendingTV.self, from: data)
                completion(.success(tv.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let url = URL(string: "\(K.baseUrl)/3/movie/upcoming?api_key=\(K.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let upcomingMovie = try JSONDecoder().decode(UpcomingMovie.self, from: data)
                completion(.success(upcomingMovie.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let url = URL(string: "\(K.baseUrl)/3/movie/popular?api_key=\(K.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let popular = try JSONDecoder().decode(Popular.self, from: data)
                completion(.success(popular.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let url = URL(string: "\(K.baseUrl)/3/movie/top_rated?api_key=\(K.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let topRated = try JSONDecoder().decode(TopRated.self, from: data)
                completion(.success(topRated.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let url = URL(string: "\(K.baseUrl)/3/discover/movie?api_key=\(K.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let discoverMovie = try JSONDecoder().decode(DiscoverMovie.self, from: data)
                completion(.success(discoverMovie.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func search(query: String, completion: @escaping (Result<[MovieRes], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(K.baseUrl)/3/search/movie?api_key=\(K.apiKey)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let searchMovie = try JSONDecoder().decode(TrendingMovie.self, from: data)
                completion(.success(searchMovie.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    func getYoutubeVideo(with query: String, completion: @escaping (Result<Item, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }

        guard let url = URL(string: "\(K.youtubeBaseUrl)q=\(query)&key=\(K.youtubeApiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(YoutubeSearch.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
}
