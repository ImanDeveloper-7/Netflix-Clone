//
//  CoreDataManager.swift
//  Netflix Clone
//
//  Created by Iman Zabihi on 10/08/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func downloadMovie(with model: MovieRes, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let movie = Movie(context: context)
        
        movie.id = Int64(model.id)
        movie.posterPath = model.posterPath
        movie.title = model.originalTitle
        movie.overview = model.overview
        movie.originalName = model.originalName
        movie.movieTitle = model.name
        
        do {
            try context.save()
            completion(.success(()))
            NotificationCenter.default.post(name: NSNotification.Name("Download"), object: nil)
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Movie>
        request = Movie.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteMovie(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
