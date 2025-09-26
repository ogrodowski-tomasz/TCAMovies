import ComposableArchitecture
import SwiftUI

struct MovieListView: View {
    
    @Bindable var store: StoreOf<MovieListReducer>
    
    var body: some View {
        NavigationStack {
            List {
                section(title: "Now playing", movies: store.nowPlaying)
                section(title: "Popular", movies: store.popular)
                section(title: "Top Rated", movies: store.topRated)
            }
            .navigationTitle("Movie List")
            .listStyle(.plain)
            .onAppear {
                store.send(.onAppear)
            }
            .navigationDestination(item: $store.scope(state: \.movieDetails, action: \.movieDetails)) { store in
                MovieDetailsView(store: store)
            }
        }
    }
    
    private func section(title: String, movies: [SingleMovieModel]) -> some View {
        Section(title) {
            ForEach(movies) { movie in
                MovieRowView(movie: movie) { selectedMovie in
                    store.send(.navigateToDetails(selectedMovie))
                }
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

#Preview {
    MovieListView(
        store: Store(
            initialState: MovieListReducer.State(),
            reducer: {
                MovieListReducer()
            }
        )
    )
}
