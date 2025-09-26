import ComposableArchitecture
import SwiftUI

struct MovieDetailsScreen: View {
    let store: StoreOf<MovieDetailsReducer>
    var body: some View {
        Group {
            if let movieDetails = store.movieDetails {
                MovieDetailsView(movie: movieDetails)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    store.favoriteButtonTitle,
                    systemImage: store.favoriteButtonImageName
                ) {
                    store.send(.favoritesButtonTapped)
                }
                .tint(.red)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.movieDetails?.title ?? "Loading...")
    }
    
    struct MovieDetailsView: View {
        let movie: MovieDetailsApiModel
        var body: some View {
            List {
                Group {
                    HStack(alignment: .top) {
                        poster
                        VStack(alignment: .leading, spacing: 5) {
                            title
                            originalTitle
                            releaseDate
                            runtime
                            rating
                            genres
                        }
                    }
                    overview
                    if movie.belongsToCollection != nil && movie.belongsToCollection?.backdropPath != nil {
                        collection
                    }
                    Spacer()
                }
                .listRowSeparator(.hidden, edges: .all)
            }
            .padding(.leading, 5)
            .listSectionSpacing(0)
            .listStyle(.plain)
            .scrollIndicators(.hidden)

        }
        
        var poster: some View {
            AsyncImage(url: URL(imagePath: movie.posterPath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(5)
                case .failure(let error):
                    Text("No image: \(error.localizedDescription)")
                @unknown default:
                    Text("Unknown")
                }
            }
        }

        var title: some View {
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
        }

        var originalTitle: some View {
            Text(movie.originalTitle ?? "-")
                .font(.caption)
                .fontWeight(.thin)
        }

        var releaseDate: some View {
            Text("Release date: " + (movie.releaseDate))
                .font(.caption)
        }

        var runtime: some View {
            Text("Runtime: " + "\(movie.runtime ?? 0)min")
                .font(.caption)
        }

        var rating: some View {
            Text("⭐️ \((movie.voteAverage ?? 0).formatted(.number))")
        }

        var genres: some View {
            VStack(alignment: .leading, spacing: 5) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(movie.genres) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(8)
                                .foregroundColor(.white)
                                .background {
                                    Capsule()
                                        .fill(Color.black)
                                }
                        }
                    }
                }
            }
            .frame(maxHeight: 70)
        }

        var overview: some View {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Plot:")
                    .font(.headline)
                Text(movie.overview ?? "")

                if let tagline = movie.tagline {
                    Text("\"\(tagline)\"")
                        .italic()
                        .padding(.top, 10)
                }
            })
                .font(.caption)
                .padding()
                .background(.gray.opacity(0.5))
                .cornerRadius(10)
        }

        var collection: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Collection: [\(movie.belongsToCollection?.id ?? -1)]")
                    .font(.headline)
                Button {
//                    if let id = movie.belongsToCollection?.id {
//                        router.navigate(to: .collectionDetails(collectionId: id))
//                    }
                } label: {
                    ZStack {
                        AsyncImage(url: URL(imagePath: movie.belongsToCollection?.backdropPath)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
        //                            .frame(width: 50, height: 75)
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(5)
                            case .failure(let error):
                                Text("error \(error.localizedDescription)")
                            @unknown default:
                                Text("unknown default")
                            }
                        }
                        Text(movie.belongsToCollection?.name ?? "Unknown")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.85)))

                    }
                }
                .buttonStyle(.borderless)
            }
        }

    }
}

#Preview {
    NavigationStack {
        MovieDetailsScreen(
            store: Store(
                initialState: MovieDetailsReducer.State(movieId: SingleMovieModel.stub.id),
                reducer: MovieDetailsReducer.init
//                ,
//                withDependencies: { dependencies in
//                    dependencies.httpClient = HTTPClient.
//                }
            )
        )
    }
}
