//
//  ContentView.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var movies: [Movie] = []
    @State private var search: String = ""
    @State private var showFavorites = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    
    @FetchRequest(
        entity: FavoriteMovie.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteMovie.id, ascending: true)]
    ) var favorites: FetchedResults<FavoriteMovie>
    
    //Subject
    let searchSubject = CurrentValueSubject<String, Never>("")
    @State private var cancellable: Set<AnyCancellable> = []
    
    let httpClient: HTTPClient
    
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                loadMovies(search: searchText)
            }.store(in: &cancellable)
    }
    
    private func loadMovies(search: String) {
        isLoading = true
        httpClient.fetchMovie(search: search)
            .sink { completion in
                isLoading = false
                switch completion {
                case .failure(let error):
                    // Handle the error and show an alert
                    self.handleError(error)
                case .finished:
                    break
                }
            } receiveValue: { movie in
                self.movies = movie
            }.store(in: &cancellable) // Here subscription will be lost if we doesn't store
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .badUrl:
                errorMessage = "Invalid URL. Please check your search term."
            case .invalidResponse:
                errorMessage = "Invalid response from the server."
            case .decodingError:
                errorMessage = "Failed to decode the response."
            case .noData:
                errorMessage = "No data received from the server."
            }
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        showErrorAlert = true
    }
    
    var body: some View {
        NavigationStack {
            List(movies) { movie in
                
                NavigationLink {
                    MovieDetailView(movie: movie)
                } label: {
                    HStack {
                        AsyncImage(url: movie.poster) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack {
                            Text(movie.title)
                                .fontWeight(.medium)
                            Text("Release year: \(movie.year)")
                                .padding(.leading)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Button {
                            toggleFavorite(movie: movie)
                        } label: {
                            Image(systemName: isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite(movie: movie) ? .red : .gray)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .id(UUID()) // Force List refresh when favorites change
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showFavorites = true
                    } label: {
                        Label("Favorites", systemImage: "heart")
                    }
                }
            }
            .sheet(isPresented: $showFavorites) {
                FavoritesView()
            }
            
            .overlay {
                Group {
                    if isLoading {
                        ProgressView()
                                                    .progressViewStyle(.circular)
                                                    .scaleEffect(1.5)
                                                    .padding()
                                                    .background(.thinMaterial)
                                                    .cornerRadius(10)
                    } else if movies.isEmpty {
                        ContentUnavailableView(
                            search.isEmpty ? "Search for Movies" : "No Movies Found",
                            systemImage: search.isEmpty ? "magnifyingglass" : "film",
                            description: Text(search.isEmpty ?
                                              "Enter a movie title to start searching." :
                                                "No movies match your search.")
                        )
                    }
                }.animation(.easeInOut, value: isLoading)
                
            }
            .onAppear {
                setupSearchPublisher()
            }
            
            .searchable(text: $search)
            .onChange(of: search) {
                // Publish the subject. It need to subscribe somewhere
                searchSubject.send(search)
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func toggleFavorite(movie: Movie) {
        withAnimation(.spring()) {
            if isFavorite(movie: movie) {
                DataController.shared.deleteFavorite(movie: movie, context: viewContext)
            } else {
                DataController.shared.addFavorite(movie: movie, context: viewContext)
            }
            try? viewContext.save()
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }
}

#Preview {
    NavigationStack {
        ContentView(httpClient: HTTPClient())
    }
}
