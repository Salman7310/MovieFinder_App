//
//  MovieDetailView.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let movie: Movie
    
    // State property to track the favorite status
    @State private var isFavoriteMovie: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: movie.poster) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Movie Details
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    DetailRow(title: "Release Year", value: movie.year)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        
        
        Button {
            toggleFavorite()
        } label: {
            Label(
                isFavoriteMovie ? "Remove from Favorites" : "Add to Favorites",
                systemImage: isFavoriteMovie ? "heart.fill" : "heart"
            )
            .foregroundColor(isFavorite() ? .red : .blue)
        }
        .padding()
        .onAppear {
            // Update the favorite status when the view appears
            isFavoriteMovie = isFavorite()
        }
    }
    
    private func toggleFavorite() {
        if DataController.shared.isFavorite(movie: movie, context: viewContext) {
            DataController.shared.deleteFavorite(movie: movie, context: viewContext)
        } else {
            DataController.shared.addFavorite(movie: movie, context: viewContext)
        }
        
        // Update the state to trigger a view update
        isFavoriteMovie.toggle()
    }
    
    private func isFavorite() -> Bool {
        DataController.shared.isFavorite(movie: movie, context: viewContext)
    }
}
