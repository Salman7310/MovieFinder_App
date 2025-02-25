//
//  FavoritesView.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FavoriteMovie.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteMovie.title, ascending: true)]
    ) var favorites: FetchedResults<FavoriteMovie>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(favorites, id: \.id) { favorite in  // Ensure uniqueness
                    NavigationLink {
                        MovieDetailView(movie: favorite.movieValue)
                    } label: {
                        FavoriteRow(favorite: favorite)
                    }
                }
                .onDelete(perform: deleteFavorites)
            }
            .overlay(emptyState)
            .navigationTitle("Favorites")
            .toolbar { EditButton() }
        }
    }
}

// MARK: - Helper Views and Extensions
private extension FavoritesView {
    var emptyState: some View {
        Group {
            if favorites.isEmpty {
                ContentUnavailableView(
                    "No Favorites",
                    systemImage: "heart.slash",
                    description: Text("Add movies to favorites by tapping the heart icon")
                )
            }
        }
    }
    
    struct FavoriteRow: View {
        let favorite: FavoriteMovie
        
        var body: some View {
            HStack {
                AsyncImage(url: favorite.posterURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "film")
                    } else {
                        ProgressView()
                    }
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                
                Text(favorite.title ?? "Unknown Title")
                    .fontWeight(.medium)
            }
        }
    }
}

extension FavoriteMovie {
    var movieValue: Movie {
        Movie(
            title: self.title ?? "Unknown Title",
            year: self.year ?? "Unknown Year",
            imdbId: self.id ?? "Unknown ID",
            poster: self.posterURL
        )
    }
    
    var posterURL: URL? {
        guard let posterString = self.poster else { return nil }
        return URL(string: posterString)
    }
}

extension FavoritesView {
    private func deleteFavorites(offsets: IndexSet) {
        offsets.map { favorites[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting favorite: \(error.localizedDescription)")
        }
    }
}


