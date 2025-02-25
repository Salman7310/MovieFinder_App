//
//  DataController.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FavoriteMovie")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func addFavorite(movie: Movie, context: NSManagedObjectContext) {
        let favorite = FavoriteMovie(context: context)
        favorite.title = movie.title
        favorite.id = movie.id
        favorite.year = movie.year
        favorite.poster = movie.poster?.absoluteString
        save(context: context)
    }
    
    func deleteFavorite(movie: Movie, context: NSManagedObjectContext) {
        let request = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        request.predicate = NSPredicate(format: "id == %@", movie.id)
        
        do {
            let favorites = try context.fetch(request)
            if let existingFavorite = favorites.first {
                context.delete(existingFavorite)
                save(context: context)
            }
        } catch {
            print("Error deleting favorite: \(error)")
        }
    }
    
    func isFavorite(movie: Movie, context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        request.predicate = NSPredicate(format: "id == %@", movie.id)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking favorite: \(error)")
            return false
        }
    }
}
